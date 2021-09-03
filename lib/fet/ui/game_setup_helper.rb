# frozen_string_literal: true

require_relative "color_scheme"

module Fet
  module Ui
    # Handles setting up the game before starting
    module GameSetupHelper
      private

      def setup_window
        setup_window_title
        setup_window_background
        setup_window_event_loop
        setup_window_update_loop
      end

      def setup_window_title
        Ruby2D::Window.set(title: "FET")
      end

      def setup_window_background
        Ruby2D::Window.set(background: Fet::Ui::ColorScheme::BLACK)
      end

      def setup_window_event_loop
        Ruby2D::Window.on(:key_down) do |event|
          handle_event_loop(event)
          score.handle_event_loop(event)
          level.handle_event_loop(event)
          timer.handle_event_loop(event)
        end

        Ruby2D::Window.on(:mouse_down) do |event|
          handle_event_loop(event)
        end
      end

      def setup_window_update_loop
        Ruby2D::Window.update do
          handle_update_loop
        end
      end
    end
  end
end
