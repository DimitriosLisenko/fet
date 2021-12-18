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

        if game.shift_held
          handle_shift_buttons(event)
        else
          handle_non_shift_buttons(event)
        end
      end

      def handle_non_shift_buttons(event)
        handle_c_key if event.key == "c"
        handle_n_key if event.key == "n"
        handle_l_key if event.key == "l"
        handle_return_key if event.key == "return"
      end

      def handle_shift_buttons(event)
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "+"].each.with_index do |button, index|
          individual_notes_music.sort[index]&.play if button == event.key
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
