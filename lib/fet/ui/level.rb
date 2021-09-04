# frozen_string_literal: true

require_relative "note_boxes"

module Fet
  module Ui
    # Holds state for the current level of the game
    class Level
      attr_accessor :game, :degrees

      def initialize(game)
        self.game = game
        self.degrees = generate_degrees
        self.midi_values = degrees.select_degrees_from_midi_values(game.note_range, game.number_of_degrees)
        self.note_boxes = NoteBoxes.new(self)
        self.key = Key.new(self)
      end

      def start
        note_boxes.start
        key.start
      end

      def degree_indices
        return midi_values.map { |midi_value| degrees.degree_index_of_midi_value(midi_value) }
      end

      def handle_event_loop(event)
        note_boxes.handle_event_loop(event)
      end

      def handle_update_loop; end

      def correct_answer_selected?
        note_boxes.note_boxes.any? { |note_box| note_box.correct? && note_box.selected }
      end

      private

      attr_accessor :midi_values, :note_boxes, :key

      def generate_degrees
        root_midi_values = game.key_type == "major" ? Fet::MAJOR_ROOT_MIDI_VALUES : Fet::MINOR_ROOT_MIDI_VALUES
        root_name, root_midi_value = root_midi_values.to_a.sample
        root_octave_value = Fet::MidiNote.new(root_midi_value).octave_number
        return Degrees.new(root_name: root_name, octave_value: root_octave_value)
      end
    end
  end
end
