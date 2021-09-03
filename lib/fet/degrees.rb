# frozen_string_literal: true

require_relative "degree"
require_relative "midi_note"

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
      return MidiNote.from_note(root_name, octave_value).midi_value
    end

    def degree_names_of_midi_value(midi_value)
      return Degree::DEGREE_NAMES[degree_index_of_midi_value(midi_value)]
    end

    def note_name_of_degree(degree_name)
      return degree_to_note_name[Degree.new(degree_name).degree_name]
    end

    def select_degrees_from_midi_values(midi_value_range, number_of_degrees)
      return select_degrees_from_midi_values_recursive(midi_value_range, [], number_of_degrees)
    end

    private

    attr_writer :root_name,
                :octave_value

    attr_accessor :degree_to_note_name

    def note_name_of_degree_internal(degree_name)
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
        result[degree_name] = note_name_of_degree_internal(degree_name)
      end
      return result
    end

    def degree_index_of_midi_value(midi_value)
      return MidiNote.new(midi_value).degree(root_midi_value)
    end

    def select_degrees_from_midi_values_recursive(all_notes, chosen_notes, number_of_degrees)
      return chosen_notes if number_of_degrees.zero?

      selected_note = all_notes.sample
      chosen_notes << selected_note

      all_notes_without_note_degree = all_notes.reject do |note|
        Fet::MidiNote.new(note).degree(root_midi_value) == Fet::MidiNote.new(selected_note).degree(root_midi_value)
      end

      select_degrees_from_midi_values_recursive(all_notes_without_note_degree, chosen_notes, number_of_degrees - 1)
    end
  end
end
