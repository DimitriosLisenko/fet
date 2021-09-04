# frozen_string_literal: true

require_relative "note_boxes"

module Fet
  module Ui
    # Holds state for the current level of the game
    class Level
      attr_accessor :game, :degrees, :question_number

      def initialize(game)
        self.game = game
        self.note_boxes = NoteBoxes.new(self)
        self.question_number = 0
        self.key = Key.new(self)
      end

      # NOTE: I'm thinking that the start method should also handle generation of a new level without overwriting everything (minimize redraw)
      def start
        self.question_number += 1
        self.degrees = generate_degrees
        self.midi_values = degrees.select_degrees_from_midi_values(game.note_range, game.number_of_degrees)

        note_boxes.start
        key.start
        start_self
      end

      def start_self
        update_music_objects
        full_question_music.play
        game.level_started_event
      end

      def degree_indices
        return midi_values.map { |midi_value| degrees.degree_index_of_midi_value(midi_value) }
      end

      def handle_event_loop(event)
        note_boxes.handle_event_loop(event)
        handle_keyboard_event(event)
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

      attr_accessor :midi_values, :note_boxes, :key, :full_question_music, :chord_progression_music, :notes_music

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
        filename = "tmp/chord_progression_and_question.mid"
        create_midilib_object("Chord Progression + Question", filename).create_full_question
        return Ruby2D::Music.new(filename)
      end

      def generate_chord_progression_music
        filename = "tmp/chord_progression.mid"
        create_midilib_object("Chord Progression", filename).create_chord_progression_of_question
        return Ruby2D::Music.new(filename)
      end

      def generate_notes_music
        filename = "tmp/question.mid"
        create_midilib_object("Question", filename).create_notes_of_question
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

      def handle_keyboard_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)
        return unless event.type == :down

        case event.key
        when "c"
          chord_progression_music.play
        when "n"
          notes_music.play
        when "return"
          start if over?
        end
      end
    end
  end
end
