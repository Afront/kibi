# TODO: Write documentation for `Kibi`
module Kibi
  VERSION = "0.1.0"
  CRLF    = "\r\n"

  CHANNEL = Channel(Char).new

  def self.put(text)
    print text.to_s + CRLF
  end

  def self.get_input
    spawn do
      CHANNEL.send(STDIN.read_char || '\0')
    end
  end

  puts "Welcome!"

  begin
    STDIN.raw do
      loop do
        get_input
        input_char = CHANNEL.receive

        if input_char.control?
          put input_char.ord
        else
          put "#{input_char.ord} #{input_char}"
        end

        break if input_char == 'q'
      end
    end
  rescue exception
    puts exception.message
  end
end
