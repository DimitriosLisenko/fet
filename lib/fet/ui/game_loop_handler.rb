# frozen_string_literal: true

require_relative "custom_event"

module Fet
  module Ui
    # Handles various events and updates for the Game object
    module GameLoopHandler
      attr_reader :shift_held

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

        handle_custom_events
      end

      def set_note_selected_event_flag
        self.note_selected_event_flag = true
      end

      def set_level_started_event_flag
        self.level_started_event_flag = true
      end

      def set_level_complete_event_flag
        self.level_complete_event_flag = true
      end

      private

      attr_accessor :note_selected_event_flag, :level_started_event_flag, :level_complete_event_flag
      attr_writer :shift_held

      def handle_keyboard_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)

        handle_shift_button(event) if event.key == "left shift" || event.key == "right shift"

        return unless event.type == :down
        return if shift_held

        stop if event.key == "q"
      end

      def handle_shift_button(event)
        case event.type
        when :down
          self.shift_held = true
        when :up
          self.shift_held = false
        end
      end

      def handle_custom_events
        handle_note_selected_event
        handle_level_started_event
        handle_level_complete_event
      end

      def handle_note_selected_event
        handle_event = note_selected_event_flag
        self.note_selected_event_flag = false
        handle_event_loop(CustomEvent.new(CustomEvent::EVENT_TYPE_NOTE_SELECTED)) if handle_event
      end

      def handle_level_started_event
        handle_event = level_started_event_flag
        self.level_started_event_flag = false
        handle_event_loop(CustomEvent.new(CustomEvent::EVENT_TYPE_LEVEL_STARTED)) if handle_event
      end

      def handle_level_complete_event
        handle_event = level_complete_event_flag
        self.level_complete_event_flag = false
        handle_event_loop(CustomEvent.new(CustomEvent::EVENT_TYPE_LEVEL_COMPLETE)) if handle_event
      end
    end
  end
end
