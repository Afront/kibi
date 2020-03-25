# TODO: Write documentation for `Kibi`
module Kibi
  VERSION = "0.1.0"
  CRLF    = "\r\n"

  def self.put(text)
    print text.to_s + CRLF
  end

  puts "Welcome!"

  STDIN.raw do
    while (input_char = STDIN.read_char) && input_char != 'q'
      if input_char.control?
        put input_char.ord
      else
        put "#{input_char.ord} #{input_char}"
      end
    end
  end
end
