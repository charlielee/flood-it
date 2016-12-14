require "console_splash"

$best_score = 0

def get_board(width, height)
  # TODO: Implement this method
  #
  # This method should return a two-dimensional array.
  # Each element of the array should be one of the
  # following values (These are "symbols", you can use
  # them like constant values):
  # :red
  # :blue
  # :green
  # :yellow
  # :cyan
  # :magenta
  #
  # It is important that this method is used because
  # this will be used for checking the functionality
  # of your implementation.
end

# Clears the screen
def clear
  system "cls" or "clear"
end

# Call the main menu
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
    # Exits the program
    exit
  else
    menu
  end
end
  

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