require 'active_support/time'

class KeyPress
  SECONDS_IN_MINUTE = 60
  EDGE = 10
  TIME_EDGE = EDGE.seconds

  DELAY = 3.seconds

  STORE_FILE_PATH = 'keypress.txt'

  attr_reader :created_at

  @collection = []

  class << self
    attr_accessor :collection

    def catch
      collection << new

      store_result
    end

    def store_result
      File.open(STORE_FILE_PATH, 'w') do |f|
        f.write(average_amount)
      end
    end

    def average_amount
      collection.keep_if do |key_press|
        key_press.created_at > TIME_EDGE.ago
      end

      collection.count * SECONDS_IN_MINUTE / EDGE
    end
  end

  def initialize
    @created_at = Time.now
  end
end

