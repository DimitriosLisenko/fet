# frozen_string_literal: true

module Fet
  module Generator
    # Class that generates MIDI files for the singing exercises
    class Singing
      def initialize(tempo:, pause:)
        self.tempo = tempo
        self.pause = pause
        self.midi_range = HIGH_SINGING_OCTAVE_RANGE
      end

      def generate
        generate_major
        generate_minor
      end

      private

      attr_accessor :tempo, :pause, :midi_range

      def generate_major
        MusicTheory::MAJOR_KEYS.each do |root_note_name|
          root_midi_value = MAJOR_ROOT_MIDI_VALUES[root_note_name]
          midi_range.each do |note_midi_value|
            create_midi_file("major", root_note_name, root_midi_value, note_midi_value)
          end
        end
      end

      def generate_minor
        MusicTheory::MINOR_KEYS.each do |root_note_name|
          root_midi_value = MINOR_ROOT_MIDI_VALUES[root_note_name]
          midi_range.each do |note_midi_value|
            create_midi_file("minor", root_note_name, root_midi_value, note_midi_value)
          end
        end
      end

      def create_midi_file(key_type, root_note_name, root_midi_value, note_midi_value)
        progression = Fet::ChordProgression.new(offset: root_midi_value, template_type: key_type).with_offset
        Fet::MidilibInterface.new(
          tempo: tempo, progression: progression, notes: [note_midi_value],
          info: generate_midi_info(key_type, root_note_name, root_midi_value, note_midi_value),
          filename: full_filename(key_type, root_note_name, root_midi_value, note_midi_value),
        ).create_singing_midi_file(pause)
      end

      def generate_midi_info(key_type, root_note_name, root_midi_value, note_midi_value)
        note_name = note_name(root_note_name, root_midi_value, note_midi_value)
        note_octave_value = Fet::MidiNote.new(note_midi_value).octave_number
        result = [
          "Key: [#{root_note_name} #{key_type}]",
          "Degree: [#{degree_name(root_note_name, root_midi_value, note_midi_value)}]",
          "Note: [#{note_name}#{note_octave_value}]",
        ]
        return result.join(" ")
      end

      def full_filename(key_type, root_note_name, root_midi_value, note_midi_value)
        result = File.join("singing", key_type)
        filename = root_note_name # note, e.g. Db
        filename += key_type == "major" ? "M" : "m" # type of note, M or m
        filename += "_" # delimiter
        filename += degree_name(root_note_name, root_midi_value, note_midi_value) # degree, e.g. b7
        filename += ".mid" # extension
        return File.join(result, filename)
      end

      def root_degrees_instance(root_note_name, root_midi_value)
        root_octave_value = Fet::MidiNote.new(root_midi_value).octave_number
        return Fet::Degrees.new(root_name: root_note_name, octave_value: root_octave_value)
      end

      def degree_name(root_note_name, root_midi_value, note_midi_value)
        degrees_instance = root_degrees_instance(root_note_name, root_midi_value)
        return degrees_instance.degree_names_of_midi_value(note_midi_value).last
      end

      def note_name(root_note_name, root_midi_value, note_midi_value)
        degrees_instance = root_degrees_instance(root_note_name, root_midi_value)
        return degrees_instance.note_name_of_degree(
          degree_name(root_note_name, root_midi_value, note_midi_value),
        )
      end
    end
  end
end
