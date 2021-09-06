# frozen_string_literal: true

require_relative "color_scheme"
require_relative "note_boxes"
require_relative "note_box_loop_handler"

module Fet
  module Ui
    # Handles drawing + events for notes
    class NoteBox
      include NoteBoxLoopHandler

      attr_accessor :note_boxes, :degree_name, :selected

      def initialize(note_boxes:, degree_name:)
        self.note_boxes = note_boxes
        self.degree_name = degree_name
      end

      def start
        self.keyboard_accidental = ""
        self.square ||= generate_square
        self.text ||= generate_text
        self.selected = false
        self.user_selected = false
        self.note_music = generate_note_music
        update_colors
      end

      def correct?
        return note_boxes.level.degree_indices.include?(degree_index)
      end

      def degree_index
        degree_instance.degree_index
      end

      private

      attr_accessor :square, :text, :note_music

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
          font: File.join(Fet.root, "assets/fonts/PTSans/PTSans-Regular.ttf"),
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
        else
          raise ImplementationError
        end
      end

      def level_over?
        return note_boxes.level.over?
      end

      def generate_note_music
        degrees = note_boxes.level.degrees

        filename = "tmp/#{degree_name}.mid"
        Fet::MidilibInterface.new(
          tempo: note_boxes.level.game.tempo,
          progression: nil,
          notes: [degrees.root_midi_value + degree_instance.degree_index],
          info: degree_name,
          filename: filename,
        ).create_notes_only

        return Ruby2D::Music.new(filename)
      end
    end
  end
end
