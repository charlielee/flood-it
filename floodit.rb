require "colorize"
require "console_splash"

# Internal: Clear the screen.
def clear
  # Work in both unix and win32 shells
  system("cls") || system("clear")
end

# Public: Initialise the program.
def init()
  # Splash screen
  splash = ConsoleSplash.new(25,88)
  splash.write_header("Flood-It", "Charles Lee", "0.0.1")
  splash.write_center(-3, "<Press enter to continue>")
  splash.write_horizontal_pattern("*")
  splash.write_vertical_pattern("*")
  splash.splash

  # Press enter to continue
  gets

  # Load the main menu
  display_menu
end

# Public: Display the main menu.
# 
# columns    - The current selected width of the game board (default: 14).
# rows       - The current selected height of the game board (default: 9).
# best_score - The lowest number of the turns the player has taken to complete
#              the game at the current board size (default: 0).
def display_menu(columns=14, rows=9, best_score=0)
  # Clear the screen
  clear

  # Display menu options
  puts "Main menu:"
  puts "s = Start game"
  puts "c = Change size"
  puts "q = Quit"

  # Display best score if there is one
  if best_score > 0
    puts "Best game: #{best_score} turns"
  else
    puts "No games played yet"
  end
  
  # User input
  print "Please enter your choice: "
  input = gets.chomp

  # Clear the menu screen
  clear

  case input
  when "s"
    # Start a new game
    start_game columns, rows, best_score
  when "c"
    # Change the width of the board
    print "Width (Currently #{ columns })? "
    width = gets.chomp.to_i

    # Change the height of the board
    print "Height (Currently #{ rows })? "
    height = gets.chomp.to_i

    # Reload the menu with the new board dimensions stored
    display_menu width, height
  when "q"
    # Exit the program
    exit
  else
    # Reload the main menu if input is not recognised
    display_menu columns, rows, best_score
  end
end

# Public: Begin a new game.
#
# columns    - The width of the game board.
# rows       - The height of the game board.
# best_score - The lowest number of the turns the player has taken to complete
#              the game at the current board size.
def start_game(columns, rows, best_score)
  cur_board      = get_board(columns, rows)
  cur_completed  = 0
  no_of_turns    = 0

  while !check_win? cur_board
    # Display the current board
    print_board cur_board

    # In-game messages
    puts "Current completion: #{ cur_completed }%"
    puts "Number of turns: #{ no_of_turns }"

    # User chooses color by entering the first letter of that color
    print "Choose a color: "
    cur_color = gets.chomp

    # Convert the letter entered into a color symbol
    cur_color = to_color cur_color

    # Return to main menu if "q" entered
    if cur_color == "q"
      display_menu columns, rows, best_score
    end

    # Check if color entered is different to the previous color entered
    if cur_color != cur_board[0][0]
       # Update color of top left square and any squares connected to it
      update_adjacent cur_board, 0, 0, cur_color
    end

    # Update number of turns
    no_of_turns += 1

    # Update percentage of board completed
    cur_completed = get_amount cur_board, cur_color

    # Clear the screen
    clear
  end

  # Display message when board is completed
  puts "You won after #{ no_of_turns } turns"
  print "<Press enter to continue>"
  gets

  # Check if score is better than the "best_score"
  if no_of_turns < best_score || best_score == 0
    display_menu columns, rows, no_of_turns
  else 
    display_menu columns, rows, best_score
  end
end

# Internal: Get a 2d array of random color symbols of a particular size.
#
# width  - The number of columns in the array.
# height - The number of rows in the array.
#
# Returns a 2d array of random color symbols.
def get_board(width, height)
  # Create a 2d array the size of the board
  board = Array.new(height) { Array.new(width) }
  colors = [:red, :blue, :green, :yellow, :cyan, :magenta]

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Get a random color symbol
      random_color = colors[rand 0...colors.length]

      # Set the value of the square to the random color symbol
      board[row][column] = random_color
    end
  end

  # Return the 2d array of random color symbols
  return board
end

# Internal: Print out a game board to the console.
#
# board - The 2d array of color symbols to display.
def print_board(board)
  height = board.length
  width = board[0].length

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Print a square the color of the array element's' value
      print "  ".colorize( :background => board[row][column])
    end

    # Print a new line every row
    puts
  end
end

# Internal: Convert a single letter into a color symbol.
#
# letter - A string of length 1 to convert to a color symbol.
#
# Returns a color symbol
def to_color(letter)
  case letter
  when "r"
    return :red
  when "g"
    return :green
  when "b"
    return :blue
  when "c"
    return :cyan
  when "m"
    return :magenta
  when "y"
    return :yellow
  else
    return letter
  end
end

# Internal: Update the color of a square and those joined to it.
#
# board     - The 2d array of color symbols to update.
# column    - The x position of the square to update.
# row       - The y position of the square to update.
# new_color - The color symbol to update value of the square to.
def update_adjacent(board, column, row, new_color)
  # Get current color of square
  old_color = board[row][column]

  # Update color of square
  board[row][column] = new_color

  # Check is square ABOVE was the same color
  if row - 1 >= 0 && old_color == board[row-1][column]
    update_adjacent board, column, row - 1, new_color
  end

  # Check if the square to the RIGHT was the same color
  if  column + 1 < board[0].length && old_color == board[row][column+1]
    update_adjacent board, column + 1, row, new_color
  end

  # Check if the square BELOW was the same color
  if row + 1 < board.length && old_color == board[row+1][column]
    update_adjacent board, column, row + 1, new_color
  end

  # Check if the square to the LEFT was the same color
  if column - 1 >= 0 && old_color == board[row][column-1]
    update_adjacent board, column - 1, row, new_color
  end

end

# Internal: Get the percentage of a board that is a particular color.
#
# board - The 2d array of color strings to use.
# color - The color to check for.
#
# Returns a value between 0 and 100.
def get_amount(board, color)
  total_squares = board.length * board[0].length
  no_of_squares = 0
  height        = board.length
  width         = board[0].length

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Increment counter if square matches selected color
      no_of_squares += 1 if color == board[row][column]
    end
  end

  # Calculate the percentage of squares that match the selected color
  return (no_of_squares.to_f / total_squares.to_f * 100).round.to_i
end

# Internal: Get whether a game has been won or not.
#
# board - The 2d array of color strings to use.
#
# Returns a Boolean.
def check_win?(board)
  total_squares     = board.length * board[0].length
  completed_squares = 0
  height            = board.length
  width             = board[0].length

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Increment counter if square matches color
      completed_squares += 1 if board[row][column] == board[0][0]
    end
  end

  # Check if all of the squares are the same color
  if total_squares == completed_squares
    return true
  else
    return false
  end
end

# Intialise the program
init
