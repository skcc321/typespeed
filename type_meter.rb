require 'io/console'

class TypeMeter
  STOP_CHAR = "\e"

  def initialize
    @watch = true
  end

  def start
    while @watch
      read_char
    end
  end

  def stop
    @watch = false
  end

  private

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

    KeyPress.catch
  ensure
    STDIN.echo = true
    STDIN.cooked!

    stop if input == STOP_CHAR
  end
end
