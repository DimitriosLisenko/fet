# frozen_string_literal: true

require_relative "color_scheme"
require_relative "note_boxes"

module Fet
  module Ui
    # Handles drawing + events for notes
    class NoteBox
      attr_accessor :note_boxes, :degree_name, :square, :text

      def initialize(note_boxes:, degree_name:)
        self.note_boxes = note_boxes
        self.degree_name = degree_name
        # self.midi_file = midi_file
        # self.music = Ruby2D::Music.new(midi_file)
      end

      def start
        self.square = generate_square
        self.text = generate_text
      end

      def handle_event_loop(event)
        handle_click_event(event)
      end

      def handle_update_loop; end

      def degree_instance
        return Fet::Degree.new(degree_name)
      end

      def correct
        return note_boxes.level.degree_indices.include?(degree_instance.degree_index)
      end

      def color
        return degree_instance.degree_accidental ? ColorScheme::GREY : ColorScheme::WHITE
      end

      def handle_event(event)
        handle_click_event(event)
      end

      private

      NOTE_BOX_SIZE = 70
      private_constant :NOTE_BOX_SIZE

      def generate_square
        return Ruby2D::Square.new(
          x: NoteBoxes::NOTE_BOX_OFFSETS[degree_name][0],
          y: NoteBoxes::NOTE_BOX_OFFSETS[degree_name][1],
          size: NOTE_BOX_SIZE,
          color: color,
        )
      end

      def generate_text
      end

      def handle_click_event(event)
        return unless event.is_a?(Ruby2D::Window::MouseEvent)
        return unless event.type == :down
        return unless event.button == :left
        return unless square.contains?(event.x, event.y)

        square.color = correct ? ColorScheme::GREEN : ColorScheme::RED
        # music.play
      end
    end
  end
end
