require 'linux_input'

class TypeMeter
  STOP_CHAR = "\e"

  def initialize
    @keyboard_file = File.open(keyboard_device)
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

  def keyboard_device
    "/dev/input/#{keyboard_event}"
  end

  def keyboard_event
    `grep -E 'Handlers|EV=' /proc/bus/input/devices | grep -B1 'EV=120013' | grep -Eo 'event[0-9]+'`.strip
  end
end
