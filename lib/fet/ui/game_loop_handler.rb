# frozen_string_literal: true

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
        handle_mouse_event(event)
        handle_keyboard_event(event)

        score.handle_event_loop(event)
        level.handle_event_loop(event)
        timer.handle_event_loop(event)
      end

      private

      def handle_mouse_event(event)
        return unless event.is_a?(Ruby2D::Window::MouseEvent)

        handle_left_click_event(event)
      end

      def handle_left_click_event(event)
        return unless event.button == :left
        return unless event.type == :down
      end

      def handle_keyboard_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)
        return unless event.type == :down
      end
    end
  end
end