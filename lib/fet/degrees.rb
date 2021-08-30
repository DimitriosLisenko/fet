# frozen_string_literal: true

require_relative "degree"
require_relative "midi_music_theory"

module Fet
  # This class handles determining the degrees for a given root
  class Degrees
    attr_reader :root_name,
                :octave_value

    def initialize(root_name:, octave_value:)
      self.root_name = root_name
      self.octave_value = octave_value
      self.degree_to_note_name = generate_degree_to_note_name
    end

    def root_midi_value
      return MidiMusicTheory.note_midi_value(root_name, octave_value)
    end

    def degree_names_of_midi_value(midi_value)
      return Degree::DEGREE_NAMES[degree_index_of_midi_value(midi_value)]
    end

    private

    attr_writer :root_name,
                :octave_value,
                :degree_to_note_name

    def note_name_of_degree(degree_name)
      degree = Degree.new(degree_name)

      notes_array = Fet::MusicTheory.notes_of_mode(root_name, "major")
      note_name = notes_array[degree.degree_value - 1]

      return Note.new(note_name).flattened_note.full_note if degree.degree_accidental == "b"
      return Note.new(note_name).sharpened_note.full_note if degree.degree_accidental == "#"

      return Note.new(note_name).full_note
    end

    def generate_degree_to_note_name
      result = {}
      Degree::DEGREE_NAMES.flatten.each do |degree_name|
        result[degree_name] = note_name_of_degree(degree_name)
      end
      return result
    end

    def degree_index_of_midi_value(midi_value)
      return MidiMusicTheory.degree_from_midi_values(root_midi_value, midi_value)
    end

    # we need the following information:
    # - note name (E, F#...)
    # - octave_value (0..9)
    # - the root midi value (which we can determine from the above)
    # - method to determine what is the Xth (#4, b5) degree for that octave
  end
end
