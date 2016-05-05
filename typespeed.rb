require 'io/console'
require 'active_support/time'

class KeyPress
  DELAY = 3.seconds

  attr_reader :created_at

  @collection = []

  def self.catch
    current_key_press = new

    if last_key_press.nil? || last_key_press.created_at + DELAY > current_key_press.created_at
      @collection << current_key_press
    else
      @collection = []
    end
    calculate_speed
  end

  def self.last_key_press
    @collection.last
  end

  def self.calculate_speed
    puts @collection.count
  end

  def initialize
    @created_at = Time.now
  end
end

def read_char
  STDIN.echo = false
  STDIN.raw!

  STDIN.getc.chr
  KeyPress.catch
ensure
  STDIN.echo = true
  STDIN.cooked!
end

read_char while(true)

