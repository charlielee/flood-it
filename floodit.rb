require "colorize"
require "console_splash"

# Internal: Clears the screen
def clear
  system "cls" or "clear"
end

# Public: Initialise the program
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

# Public: Display the main menu
# 
# columns    - The currently selected width of the game board
# rows       - The currently selected height of the game board
# best_score - The lowest number of the turns the player has taken
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
      # Starts the game with a new board
      start_game columns, rows, best_score
    when "c"
      # Change the width of the board
      print "Width (Currently #{columns})? "
      width = gets.chomp.to_i

      # Change the height of the board
      print "Height (Currently #{rows})? "
      height = gets.chomp.to_i

      # Reload the menu with the new dimensions stored
      display_menu width, height
    when "q"
      # Exit the program
      exit
    else
      # Reload the main menu if input is not recognised
      display_menu columns, rows, best_score
  end
end

# Public: Begin a new game
#
# columns    - The width of the board
# rows       - The height of the board
# best_score - The lowest number of the turns the player has taken
def start_game(columns, rows, best_score)
  cur_board      = get_board(columns, rows)
  cur_completed  = 0
  no_of_turns    = 0

  while !check_win cur_board
    # Display the current board
    print_board cur_board

    # Messages
    puts "Current completion: #{cur_completed}%"
    puts "Number of turns: #{no_of_turns}"

    # User chooses color by entering the first letter of that color
    print "Choose a color: "
    cur_color = gets.chomp

    # Convert the string of length 1 to a color symbol
    cur_color = to_color cur_color

    # Return to main menu if "q" entered
    if (cur_color == "q")
      display_menu columns, rows, best_score
    end

   # Check if color entered is different to the previous color entered
    if cur_color != cur_board[0][0]
       # Update color of top left square and any squares joint to it
      update_adjacent cur_board, 0, 0, cur_color
    end

    # Update the number of turns
    no_of_turns += 1

    # Update amount completed
    cur_completed = get_amount cur_board, cur_color

    # Clear the screen
    clear
  end

  # When board is completed
  puts "You won after #{no_of_turns} turns"
  print "<Press enter to continue>"
  gets

  if (no_of_turns < best_score || best_score == 0)
    display_menu columns, rows, no_of_turns
  else 
    display_menu columns, rows, best_score
  end
end

# Internal: Get a 2d array of random colors that is the size of the board
#
# width  - The width of the board
# height - The height of the board
#
# Returns a 2d array of random colors equal to the size of the board
def get_board(width, height)
  # Create a 2d array of the size of the board
  board = Array.new(height) { Array.new(width) }
  colors = [:red, :blue, :green, :yellow, :cyan, :magenta]

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Get a random color
      random_color = colors[rand 0...colors.length]

      # Set each square as a random color
      board[row][column] = random_color
    end
  end

# Return a 2d array of random colors
  return board
end

# Internal: Prints out a board to the console 
#
# board - The 2d array of colors to display
def print_board(board)
  height = board.length
  width = board[0].length

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Print a colored square matching the value of the array element
      print "  ".colorize( :background => board[row][column])
    end

    # Print a new line every row
    puts
  end
end

# Internal: Converts a single letter into a color symbol
#
# letter - A string of length 1 to convert to a color symbol
#
# Returns the color symbol beginning with the letter entered
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

# Internal: Change a square to a new color and update the squares joined to it that were previously the same color
#
# board  - The 2d array of colors to use
# column - The x position of the square to update
# row    - The y position of the square to update
# new_color  - The color to update the square to
def update_adjacent(board, column, row, new_color)
  # Get current color of selected square
  old_color = board[row][column]

  # Update color of selected square
  board[row][column] = new_color

  # Check is square ABOVE was the same color
  if (row-1 >= 0) && old_color == board[row-1][column]
    update_adjacent board, column, row-1, new_color
  end

  # Check if the square to the RIGHT was the same color
  if  (column+1 < board[0].length) && old_color == board[row][column+1]
    update_adjacent board, column+1, row, new_color
  end

  # Check if the square BELOW was the same color
  if (row+1 < board.length) && old_color == board[row+1][column]
    update_adjacent board, column, row+1, new_color
  end

  # Check if the square to the LEFT was the same color
  if (column-1 >= 0) && old_color == board[row][column-1]
    update_adjacent board, column-1, row, new_color
  end

end

# Internal: Get the percentage of squares that are a particular color
#
# board - The 2d array of colors to use
# color - The color to check for
#
# Returns a value between 1 and 100 of how much of the board is the selected color
def get_amount(board, color)
  total_squares = board.length * board[0].length
  no_of_squares = 0
  height        = board.length
  width         = board[0].length

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Iterate if square of board matches color
      no_of_squares += 1 if (color == board[row][column])
    end
  end

  # Calculate the percentage of squares that match the selected color
  return (no_of_squares.to_f / total_squares.to_f * 100).round.to_i
end

# Internal: Get whether a game has been won or not
#
# board - The 2d array of colors to use
#
# Returns a boolean of the game's completion status
def check_win(board)
  total_squares = board.length * board[0].length
  completed_squares = 0
  height        = board.length
  width         = board[0].length

  # Loop through each square of the board
  (0...height).each do |row|
    (0...width).each do |column|
      # Iterate if square of board is same color as top left corner square
      completed_squares += 1 if (board[row][column] == board[0][0])
    end
  end

  if total_squares == completed_squares
    return true
  else
    return false
  end
end

# Intialise the program
init