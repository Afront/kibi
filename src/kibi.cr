# TODO: Write documentation for `Kibi`
module Kibi
  VERSION = "0.1.0"
  CRLF    = "\r\n"

  CHANNEL = Channel(Char).new

  def self.clear_screen
    "\x1b[2J"
  end

  def self.get_cursor_position
    buf = Array.new(32) { |i| '\0' }

    # [] of Char # Array(Char).new(32)
    put "\x1b[6n"
    31.times do |i|
      get_input
      break unless (buf[i] = CHANNEL.receive) && buf[i] != 'R'
    end

    buf.compact_map { |c| c.to_i? }
  end

  def self.reposition_cursor
    "\x1b[H"
  end

  def self.place_tildes
    "~#{CRLF}" * `stty size`.partition(' ').first.to_i + '~'
  end

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
    put clear_screen +
        reposition_cursor +
        place_tildes +
        reposition_cursor
  end

  begin
    STDIN.raw do
      loop do
        refresh_screen
        get_cursor_position
        reposition_cursor
        break if process_input == :exit
      end
    end
    puts clear_screen
  rescue exception
    puts clear_screen + exception.message
  ensure
    # clear_screen
    # get_cursor_position
  end
end
