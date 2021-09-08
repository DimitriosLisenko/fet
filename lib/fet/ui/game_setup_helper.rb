# frozen_string_literal: true

require_relative "color_scheme"

module Fet
  module Ui
    # Handles setting up the game before starting
    module GameSetupHelper
      def custom_events_processing?
        processing_custom_event_mutex.synchronize do
          return !custom_event_queue.empty? || !processing_custom_event.nil?
        end
      end

      private

      attr_accessor :event_loop_mutex, :custom_event_queue,
                    :processing_custom_event, :processing_custom_event_mutex, :processing_custom_event_condition_variable

      def initialize_synchronization_primitives
        self.event_loop_mutex = Mutex.new
        self.custom_event_queue = Queue.new

        self.processing_custom_event_mutex = Mutex.new
        self.processing_custom_event_condition_variable = ConditionVariable.new
        self.processing_custom_event = nil
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
          while set_processing_custom_event
            event_loop_mutex.synchronize { handle_event_loop(processing_custom_event) }
            reset_processing_custom_event
          end
        end
      end

      def set_processing_custom_event
        processing_custom_event_mutex.synchronize do
          processing_custom_event_condition_variable.wait(processing_custom_event_mutex) until processing_custom_event.nil? && !custom_event_queue.empty?
          self.processing_custom_event = custom_event_queue.pop
        end
      end

      def reset_processing_custom_event
        processing_custom_event_mutex.synchronize do
          self.processing_custom_event = nil
          processing_custom_event_condition_variable.signal
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
