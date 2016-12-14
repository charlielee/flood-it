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
  splash.write_center(-3, "<Press any key to continue>")
  splash.write_horizontal_pattern("*")
  splash.write_vertical_pattern("*")
  splash.splash

  # Press any key to continue
  gets
  clear

  # Load the main menu
  display_menu
end

# Public: Display the main menu
# 
# columns    - The currently selected width of the game board
# rows       - The currently selected height of the game board
# best_score - The lowest number of the turns the player has taken to complete the game
def display_menu(columns=14, rows=9, best_score=0)
  # Display menu options
  puts "Main menu:"
  puts "s = Start game"
  puts "c = Change size"
  puts "q = Quit"

  # Display best score if there is one
  if best_score > 0
    puts "Best game: #{$best_score} turns"
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
      start_game columns, rows
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
# columns - The width of the board
# rows    - The height of the board
def start_game(columns, rows)
  cur_board      = get_board(columns, rows)
  cur_completion = 0
  no_of_turns    = 0
  completed      = false

  while completed == false
    # Display the current board
    print_board cur_board

    # Messages
    puts "Current completion: #{cur_completion}"
    puts "Number of turns: #{no_of_turns}"

    # User chooses a color by entering the first letter of that color
    print "Choose a color: "
    cur_color = gets.chomp

    # Convert the string of length 1 to a color symbol
    cur_color = to_color cur_color

    # Update color of top left square and any other squares that were previously the same color as it
    update_adjacent cur_board, 0, 0, cur_color

    clear
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
  if old_color == board[row-1][column] && (row-1 >= 0)
    update_adjacent board, column, row-1, new_color
  end

  # Check if the square to the RIGHT was the same color
  if old_color == board[row][column+1]
    update_adjacent board, column+1, row, new_color
  end

  # Check if the square BELOW was the same color
  if old_color == board[row+1][column] 
    update_adjacent board, column, row+1, new_color
  end

  # Check if the square to the LEFT was the same color
  if old_color == board[row][column-1] && (column-1 >= 0)
    update_adjacent board, column-1, row, new_color
  end

end

# Internal: Convert a single letter into a color symbol
#
# color - A string of length 1 to convert to a color symbol
def to_color(color)
  case color
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
      return false
  end
end

init