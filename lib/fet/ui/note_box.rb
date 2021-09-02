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
        return unless event.is_a?(Ruby2D::Window::MouseEvent)
        return unless event.type == :down
        return unless event.button == :left
        return unless square.contains?(event.x, event.y)

        music.play
      end
    end
  end
end
