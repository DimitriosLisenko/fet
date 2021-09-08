# frozen_string_literal: true

require_relative "color_scheme"

module Fet
  module Ui
    # Handles setting up the game before starting
    module GameSetupHelper
      private

      attr_accessor :event_loop_mutex, :custom_event_queue

      def initialize_synchronization_primitives
        self.event_loop_mutex = Mutex.new
        self.custom_event_queue = ProcessingQueue.new
      end

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
        Thread.abort_on_exception = true
        Thread.new do
          while custom_event_queue.set_processing_item
            event_loop_mutex.synchronize { handle_event_loop(custom_event_queue.processing_item) }
            custom_event_queue.reset_processing_item
          end
        end
      end

      # NOTE: don't test coverage for these methods because this is more of a test of the Ruby2D library
      # :nocov:
      def setup_window_event_loop
        Ruby2D::Window.on(:key_down) do |event|
          event_loop_mutex.synchronize { handle_event_loop(event) }
        end

        Ruby2D::Window.on(:mouse_down) do |event|
          event_loop_mutex.synchronize { handle_event_loop(event) }
        end
      end
      # :nocov:

      # NOTE: don't test coverage for these methods because this is more of a test of the Ruby2D library
      # :nocov:
      def setup_window_update_loop
        Ruby2D::Window.update do
          event_loop_mutex.synchronize { handle_update_loop }
        end
      end
      # :nocov:
    end
  end
end
