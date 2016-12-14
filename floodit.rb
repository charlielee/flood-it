require "colorize"
require "console_splash"

$best_score = 0   # can remove by making score a parameter of menu method
$columns    = 14 # can remove by making columns and rows parameters of start_game
$rows       = 9 # can remove by making columns and rows parameters of start_game

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
  gets()
  clear()

  # Load the main menu
  menu()
end

# Public: Display the main menu
def menu
  puts "Main menu:"
  puts "s = Start game"
  puts "c = Change size"
  puts "q = Quit"

  # Display high score if there is one
  if $best_score > 0
    puts "Best game: #{$best_score} turns"
  else
    puts "No games played yet"
  end
  
  # User input
  print "Please enter your choice: "
  input = gets.chomp

  clear()

  if input == "s"
    # Starts the game with a new board
    puts "START"
  elsif input == "c"
    # Change the size of the board
    puts "CHANGE SIZE"
  elsif input == "q"
    # Exit the program
    exit
  else
    # Reload the main menu if input is not recognised
    menu
  end
end

# Public: Begin a new game
def start_game
  cur_board      = get_board($columns, $rows)
  cur_completion = 0
  no_of_turns    = 0
  completed      = false

  while completed == false
    # Display the current board
    print_board = cur_board

    # Messages
    puts "Current completion: #{cur_completion}"
    puts "Number of turns: #{no_of_turns}"

    # User chooses a color
    print "Choose a color: "
    cur_color = gets.chomp
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
  def print_board(board)
    height = board.length
    width = board[0].length

    # Loop through each square of the board
    (0...height).each do |row|
      # Print a new line every row
      puts
      (0...width).each do |column|
        # Print a colored square matching the value of the array element
        print "  ".colorize( :background => board[row][column])
      end
    end
  end
end