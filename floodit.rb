require "console_splash"

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

# Splash screen
splash = ConsoleSplash.new(25,88)
splash.write_header("Flood-It", "Charles Lee", "0.0.1")
splash.write_center(-3, "<Press any key to continue>")
splash.write_horizontal_pattern("*")
splash.write_vertical_pattern("*")
splash.splash

# Press any key to continue
gets()
system "clear"