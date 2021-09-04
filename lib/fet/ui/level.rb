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

        self.full_question = generate_full_question
        full_question.play
      end

      def degree_indices
        return midi_values.map { |midi_value| degrees.degree_index_of_midi_value(midi_value) }
      end

      def handle_event_loop(event)
        note_boxes.handle_event_loop(event)
      end

      def handle_update_loop; end

      def over?
        return degree_indices.all? do |degree_index|
          note_boxes.note_boxes.any? { |note_box| note_box.selected && note_box.degree_index == degree_index }
        end
      end

      def answered_correctly?
        over? && note_boxes.note_boxes.none? { |note_box| note_box.selected && !note_box.correct? }
      end

      private

      attr_accessor :midi_values, :note_boxes, :key, :full_question

      def generate_degrees
        root_midi_values = game.key_type == "major" ? Fet::MAJOR_ROOT_MIDI_VALUES : Fet::MINOR_ROOT_MIDI_VALUES
        root_name, root_midi_value = root_midi_values.to_a.sample
        root_octave_value = Fet::MidiNote.new(root_midi_value).octave_number
        return Degrees.new(root_name: root_name, octave_value: root_octave_value)
      end

      def generate_full_question
        progression = Fet::ChordProgression.new(offset: degrees.root_midi_value, template_type: game.key_type).with_offset
        Fet::MidilibInterface.new(
          tempo: game.tempo,
          progression: progression,
          notes: midi_values,
          info: "Chord Progression + Question",
          filename: "tmp/chord_progression_and_question.mid",
        ).create_listening_midi_file
        return Ruby2D::Music.new("tmp/chord_progression_and_question.mid")
      end
    end
  end
end
