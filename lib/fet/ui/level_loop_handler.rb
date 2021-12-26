# frozen_string_literal: true

require_relative "custom_event"
require_relative "key"
require_relative "note_boxes"

module Fet
  module Ui
    # Handles events for the Level class
    module LevelLoopHandler
      def handle_event_loop(event)
        handle_keyboard_event(event)
        handle_level_complete_event(event)
        note_boxes.handle_event_loop(event)
      end

      def handle_update_loop; end

      private

      def handle_keyboard_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)
        return unless event.type == :down
        return if game.shift_held

        handle_key_down_event(event)
      end

      def handle_key_down_event(event)
        case event.key
        when "c"
          handle_c_key
        when "n"
          handle_n_key
        when "l"
          handle_l_key
        when "return"
          handle_return_key
        end
      end

      def handle_c_key
        chord_progression_music.play
      end

      def handle_n_key
        notes_music.play
      end

      def handle_l_key
        full_question_music.loop = true
        full_question_music.play
      end

      def handle_return_key
        return unless over?

        start
      end

      # NOET: It seems that until the event loop finishes, the window updates don't happen.
      #       Specifically here, selecting the correct answer will set color on a note box, but that change
      #       does not take effect until we're out of the event loop, but by then we've already started a
      #       new level, so the color change never shows.
      def handle_level_complete_event(event)
        return unless event.is_a?(CustomEvent) && event.type == CustomEvent::EVENT_TYPE_LEVEL_COMPLETE

        start if answered_correctly? && game.config.next_on_correct
      end
    end
  end
end
