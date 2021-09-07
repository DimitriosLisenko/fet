# frozen_string_literal: true

require_relative "color_scheme"

module Fet
  module Ui
    # Handles setting up the game before starting
    module GameSetupHelper
      EVENT_LOOP_MUTEX = Mutex.new
      CUSTOM_EVENT_QUEUE = Queue.new

      private

      def setup_window
        setup_window_title
        setup_window_background
        setup_custom_event_loop
        setup_window_event_loop
        setup_window_update_loop
      end

      def setup_window_title
        Ruby2D::Window.set(title: "FET")
      end

      def setup_window_background
        Ruby2D::Window.set(background: Fet::Ui::ColorScheme::BLACK)
      end

      def setup_custom_event_loop
        Thread.new do
          while (event = CUSTOM_EVENT_QUEUE.pop)
            EVENT_LOOP_MUTEX.synchronize { handle_event_loop(event) }
          end
        end
      end

      # NOTE: don't test coverage for these methods because this is more of a test of the Ruby2D library
      # :nocov:
      def setup_window_event_loop
        Ruby2D::Window.on(:key_down) do |event|
          EVENT_LOOP_MUTEX.synchronize { handle_event_loop(event) }
        end

        Ruby2D::Window.on(:mouse_down) do |event|
          EVENT_LOOP_MUTEX.synchronize { handle_event_loop(event) }
        end
      end
      # :nocov:

      # NOTE: don't test coverage for these methods because this is more of a test of the Ruby2D library
      # :nocov:
      def setup_window_update_loop
        Ruby2D::Window.update do
          EVENT_LOOP_MUTEX.synchronize { handle_update_loop }
        end
      end
      # :nocov:
    end
  end
end
