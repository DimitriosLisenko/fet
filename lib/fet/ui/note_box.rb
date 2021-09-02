# frozen_string_literal: true

module Fet
  module Ui
    # Handles drawing + events for notes
    class NoteBox
      attr_accessor :x, :y, :color, :text, :midi_file, :size, :music, :square

      DEFAULT_SIZE = 70

      def initialize(x:, y:, color:, text:, midi_file:, size: DEFAULT_SIZE)
        self.x = x
        self.y = y
        self.color = color
        self.text = text
        self.midi_file = midi_file
        self.music = Ruby2D::Music.new(midi_file)
        self.size = size
      end

      def draw
        self.square = Ruby2D::Square.new(x: x, y: y, size: size, color: color)
      end

      def handle_event(event)
        handle_click_event(event)
        handle_key_event(event)
      end

      def handle_click_event(event)
        return unless event.is_a?(Ruby2D::Window::MouseEvent)
        return unless event.type == :down
        return unless event.button == :left
        return unless square.contains?(event.x, event.y)

        music.play
      end

      def handle_key_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)
        return unless event.type == :down

        play = case event.key
               when "a"
                 text == "1"
               when "s"
                 text == "2"
               when "d"
                 text == "3"
               when "f"
                 text == "4"
               when "g"
                 text == "5"
               when "h"
                 text == "6"
               when "j"
                 text == "7"
               when "w"
                 text == "b2"
               when "e"
                 text == "b3"
               when "t"
                 text == "b5"
               when "y"
                 text == "b6"
               when "u"
                 text == "b7"
               end

        music.play if play
      end
    end
  end
end
