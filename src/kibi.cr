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

  def self.process_input
    get_input
    input_char = CHANNEL.receive

    case input_char
    when 23.chr
      return :exit
    end
  end

  def self.refresh_screen
    # Safe code: "\x1b[2J".bytes.each { |byte| STDOUT.write_byte byte }
    STDOUT.write("\x1b[2J".to_slice)
  end

  puts "Welcome!"

  begin
    STDIN.raw do
      loop do
        refresh_screen
        break if process_input == :exit
      end
    end
  rescue exception
    puts exception.message
  end
end
