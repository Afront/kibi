# TODO: Write documentation for `Kibi`
module Kibi
  VERSION = "0.1.0"

  puts "Welcome!"

  STDIN.raw do
    while (input_char = STDIN.read_char) && input_char != 'q'
    end
  end
end
