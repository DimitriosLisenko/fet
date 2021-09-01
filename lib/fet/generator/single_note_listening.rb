# frozen_string_literal: true

module Fet
  module Generator
    # Class that generates MIDI files for the single note listening exercises
    class SingleNoteListening
      def initialize(tempo:, directory_prefix: "")
        self.tempo = tempo
        self.note = Fet::Note.new("C")
        self.octave_value = 4
        self.midi_value = MidiNote.from_note(note.full_note, octave_value).midi_value
        self.directory_prefix = directory_prefix
      end

      def generate
        MusicTheory::MAJOR_KEYS.each do |root_note_name|
          root_midi_value = MAJOR_ROOT_MIDI_VALUES[root_note_name]
          create_midi_file("major", root_note_name, root_midi_value)
        end

        MusicTheory::MINOR_KEYS.each do |root_note_name|
          root_midi_value = MINOR_ROOT_MIDI_VALUES[root_note_name]
          create_midi_file("minor", root_note_name, root_midi_value)
        end
      end

      private

      attr_accessor :tempo, :note, :octave_value, :midi_value, :directory_prefix

      def create_midi_file(key_type, root_note_name, root_midi_value)
        progression = Fet::ChordProgression.new(offset: root_midi_value, template_type: key_type).with_offset
        Fet::MidilibInterface.new(
          tempo: tempo, progression: progression, notes: [midi_value],
          info: generate_midi_info(key_type, root_note_name, root_midi_value),
          filename: full_filename(key_type, root_note_name, root_midi_value),
        ).create_listening_midi_file
      end

      def generate_midi_info(key_type, root_note_name, root_midi_value)
        result = [
          "Key: [#{root_note_name} #{key_type}]",
          "Degree: [#{degree_name(root_note_name, root_midi_value)}]",
          "Note: [#{note.full_note}#{octave_value}]",
        ]
        return result.join(" ")
      end

      def full_filename(key_type, root_note_name, root_midi_value)
        result = File.join(*[directory_prefix, "listening_single_note", key_type].reject(&:empty?))
        filename = root_note_name # note, e.g. Db
        filename += key_type == "major" ? "M" : "m" # type of note, M or m
        filename += "_" # delimiter
        filename += degree_name(root_note_name, root_midi_value) # degree, e.g. b7
        filename += ".mid" # extension
        return File.join(result, filename)
      end

      def degree_name(root_note_name, root_midi_value)
        root_octave_value = Fet::MidiNote.new(root_midi_value).octave_number
        degrees_instance = Fet::Degrees.new(root_name: root_note_name, octave_value: root_octave_value)
        degree_name = degrees_instance.degree_names_of_midi_value(midi_value).last
        return degree_name
      end
    end
  end
end
