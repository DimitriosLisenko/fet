# frozen_string_literal: true

require_relative "color_scheme"
require_relative "note_boxes"
require_relative "note_box_loop_handler"

module Fet
  module Ui
    # Handles drawing + events for notes
    class NoteBox
      include NoteBoxLoopHandler

      attr_accessor :note_boxes, :degree_name, :square, :text, :selected

      def initialize(note_boxes:, degree_name:)
        self.note_boxes = note_boxes
        self.degree_name = degree_name
        # self.midi_file = midi_file
        # self.music = Ruby2D::Music.new(midi_file)
      end

      def start
        self.keyboard_accidental = ""
        self.square = generate_square
        self.text = generate_text
      end

      def correct?
        return note_boxes.level.degree_indices.include?(degree_instance.degree_index)
      end

      private

      NOTE_BOX_SIZE = 70
      TEXT_SIZE = 36
      TEXT_X_FOR_NATURAL_OFFSET = 26
      TEXT_X_FOR_ACCIDENTAL_OFFSET = 16
      TEXT_Y_OFFSET = 13
      private_constant :NOTE_BOX_SIZE, :TEXT_SIZE, :TEXT_X_FOR_NATURAL_OFFSET, :TEXT_X_FOR_ACCIDENTAL_OFFSET, :TEXT_Y_OFFSET

      def generate_square
        return Ruby2D::Square.new(
          x: NoteBoxes::NOTE_BOX_OFFSETS[degree_name][0],
          y: NoteBoxes::NOTE_BOX_OFFSETS[degree_name][1],
          size: NOTE_BOX_SIZE,
          color: color,
        )
      end

      def generate_text
        return Ruby2D::Text.new(
          degree_name,
          x: square.x + text_x_offset, y: square.y + text_y_offset,
          font: "assets/fonts/PTSans/PTSans-Regular.ttf",
          size: TEXT_SIZE,
          color: text_color,
        )
      end

      def text_x_offset
        return degree_instance.degree_accidental ? TEXT_X_FOR_ACCIDENTAL_OFFSET : TEXT_X_FOR_NATURAL_OFFSET
      end

      def text_y_offset
        return TEXT_Y_OFFSET
      end

      def degree_instance
        return Fet::Degree.new(degree_name)
      end

      def color
        return correct? ? ColorScheme::GREEN : ColorScheme::RED if selected

        return degree_instance.degree_accidental ? ColorScheme::GREY : ColorScheme::WHITE
      end

      def text_color
        case color
        when ColorScheme::GREY, ColorScheme::GREEN, ColorScheme::RED
          return ColorScheme::WHITE
        when ColorScheme::WHITE
          return ColorScheme::BLACK
        end
      end

      def level_over?
        return note_boxes.level.correct_answer_selected?
      end
    end
  end
end
