# TODO: Write documentation for `Kibi`
module Kibi
  VERSION = "0.1.0"

  puts "Welcome!"

  STDIN.raw do
    while (input_char = STDIN.read_char) && input_char != 'q'
      if input_char.control?
        puts input_char.ord
      else
        puts "#{input_char.ord} #{input_char}"
      end
    end
  end
end
