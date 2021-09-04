# frozen_string_literal: true

module Fet
  module Ui
    # Custom events for the event loop
    class CustomEvent
      attr_accessor :type

      EVENT_TYPE_NOTE_SELECTED = :note_selected
      EVENT_TYPE_LEVEL_STARTED = :level_started
      EVENT_TYPE_LEVEL_COMPLETE = :level_complete

      def initialize(type)
        self.type = type
      end
    end
  end
end

# NOTE: alternatively I started monkey patching the Ruby2D::Window class, though it's probably not the best idea
# but it WOULD let us call events outside of the standard Ruby2D events.
# module Ruby2D
#   class Window
#     CustomEvent = Struct.new(:type)
#     @events[:custom] = {}
#
#     def custom_callback(type)
#       @events[:custom].each do |_id, e|
#         e.call(customEvent.new(type))
#       end
#     end
#   end
# end
