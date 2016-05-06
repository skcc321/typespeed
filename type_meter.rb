require 'linux_input'

class TypeMeter
  STOP_CHAR = "\e"
  KEYBOARD_FILE = '/dev/input/event14'

  def initialize
    @keyboard_file = File.open(KEYBOARD_FILE)
    @watch = true
  end

  def start
    loop do
      break unless @watch
      catch_key_press
    end
  end

  def stop
    @watch = false
  end

  private

  def catch_key_press
    raw_event = @keyboard_file.read LinuxInput::InputEvent.size
    raw_event_ptr = FFI::MemoryPointer.from_string(raw_event)
    event = LinuxInput::InputEvent.new(raw_event_ptr)
    return unless event[:type] == 1 && event[:value] == 1

    KeyPress.catch(event)
  end
end
