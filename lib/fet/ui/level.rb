# frozen_string_literal: true

require_relative "custom_event"
require_relative "key"
require_relative "level_loop_handler"
require_relative "note_boxes"

module Fet
  module Ui
    # Holds state for the current level of the game
    class Level
      attr_accessor :game, :question_number, :note_boxes, :key, :degrees

      include LevelLoopHandler

      def initialize(game)
        self.game = game
        self.question_number = 0
        self.note_boxes = NoteBoxes.new(self)
        self.key = Key.new(self)
      end

      def start
        start_self
        note_boxes.start
        key.start

        # TODO: This is not ideal because we're piggybacking on the normal events at the moment,
        # but there's no event here to piggyback on, so the handler has to be called manually.
        game.set_level_started_event_flag
        game.handle_event_loop(nil)
      end

      def degree_indices
        return midi_values.map { |midi_value| degrees.degree_index_of_midi_value(midi_value) }
      end

      def over?
        return degree_indices.all? do |degree_index|
          note_boxes.note_boxes.any? { |note_box| note_box.selected && note_box.degree_index == degree_index }
        end
      end

      def answered_correctly?
        over? && note_boxes.note_boxes.none? { |note_box| note_box.selected && !note_box.correct? }
      end

      private

      attr_accessor :midi_values, :full_question_music, :chord_progression_music, :notes_music

      # TODO: to allow for single-note listening exercises, the only change required is to set self.midi_values = [SOME_VALUE] here
      def start_self
        self.question_number += 1
        self.degrees = generate_degrees
        self.midi_values = degrees.select_degrees_from_midi_values(game.note_range, game.number_of_degrees, game.limit_degrees)

        update_music_objects
        # play_full_question # for listening exercises
        play_chord_progression # for singing exercises
      end

      def play_full_question
        full_question_music.play
      end

      def play_chord_progression
        chord_progression_music.play
      end

      def generate_degrees
        root_midi_values = game.key_type == "major" ? Fet::MAJOR_ROOT_MIDI_VALUES : Fet::MINOR_ROOT_MIDI_VALUES
        root_name, root_midi_value = root_midi_values.to_a.sample
        root_octave_value = Fet::MidiNote.new(root_midi_value).octave_number
        return Degrees.new(root_name: root_name, octave_value: root_octave_value)
      end

      def update_music_objects
        self.full_question_music = generate_full_question_music
        self.chord_progression_music = generate_chord_progression_music
        self.notes_music = generate_notes_music
      end

      def generate_full_question_music
        filename = File.join(game.tmp_directory, "chord_progression_and_question.mid")
        create_midilib_object("Chord Progression + Question", filename).create_full_question
        return Ruby2D::Music.new(filename)
      end

      def generate_chord_progression_music
        filename = File.join(game.tmp_directory, "chord_progression.mid")
        create_midilib_object("Chord Progression", filename).create_chord_progression_of_question
        return Ruby2D::Music.new(filename)
      end

      def generate_notes_music
        filename = File.join(game.tmp_directory, "question.mid")
        create_midilib_object("Question", filename).create_notes_only
        return Ruby2D::Music.new(filename)
      end

      def create_midilib_object(info, filename)
        progression = Fet::ChordProgression.new(offset: degrees.root_midi_value, template_type: game.key_type).with_offset
        Fet::MidilibInterface.new(
          tempo: game.tempo,
          progression: progression,
          notes: midi_values,
          info: info,
          filename: filename,
        )
      end
    end
  end
end
