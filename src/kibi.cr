# TODO: Write documentation for `Kibi`
module Kibi
  VERSION           = "0.1.0"
  CRLF              = "\r\n"
  CLEAR_SCREEN      = "\x1b[2J"
  TILDE_CLEAR       = "~\x1b[K"
  REPOSITION_CURSOR = "\x1b[H"
  CHANNEL           = Channel(Char).new

  def self.modify_cursor(hide = true)
    "\x1b[?25#{hide ? "l" : "h"}"
  end

  def self.get_cursor_position
    buf = Array.new(32) { |i| '\0' }

    put "\x1b[6n"
    31.times do |i|
      get_input
      break unless (buf[i] = CHANNEL.receive) && buf[i] != 'R'
    end

    buf.compact_map { |c| c.to_i? }
  end

  def self.place_tildes
    (TILDE_CLEAR + CRLF) * `stty size`.partition(' ').first.to_i + TILDE_CLEAR
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
    put modify_cursor +
        CLEAR_SCREEN +
        REPOSITION_CURSOR +
        place_tildes +
        REPOSITION_CURSOR +
        modify_cursor(hide: false)
  end

  begin
    STDIN.raw do
      loop do
        refresh_screen
        # get_cursor_position
        break if process_input == :exit
      end
    end
    puts CLEAR_SCREEN
  rescue exception
    puts CLEAR_SCREEN, exception.message
  ensure
    # clear_screen
    # get_cursor_position
  end
end
