# frozen_string_literal: true

require_relative "custom_event"

module Fet
  module Ui
    # Handles various events and updates for the Game object
    module GameLoopHandler
      def handle_update_loop
        score.handle_update_loop
        level.handle_update_loop
        timer.handle_update_loop
      end

      def handle_event_loop(event)
        handle_keyboard_event(event)

        # NOTE: score must handle event before level because level event could recreate the whole level
        score.handle_event_loop(event)
        level.handle_event_loop(event)
        timer.handle_event_loop(event)
      end

      def note_selected_event
        push_custom_event(CustomEvent.new(CustomEvent::EVENT_TYPE_NOTE_SELECTED))
      end

      def level_started_event
        push_custom_event(CustomEvent.new(CustomEvent::EVENT_TYPE_LEVEL_STARTED))
      end

      def level_complete_event
        push_custom_event(CustomEvent.new(CustomEvent::EVENT_TYPE_LEVEL_COMPLETE))
      end

      private

      def push_custom_event(custom_event)
        custom_event_queue.push(custom_event)
        processing_custom_event_condition_variable.broadcast
      end

      def handle_keyboard_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)
        return unless event.type == :down

        stop if event.key == "q"
      end
    end
  end
end
