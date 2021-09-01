# frozen_string_literal: true

require "test_helper"
require_relative "test_helpers/hardcoded_midi_values"

module Fet
  class DegreesTest < Minitest::Test
    include TestHelpers::HardcodedMidiValues

    ALL_DEGREES = Fet::Degree::DEGREE_NAMES.flatten

    MAJOR_DEGREES = {
      "C" => ["C", "C#", "Db", "D", "D#", "Eb", "E", "F", "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"],
      "C#" => ["C#", "Cx", "D", "D#", "Dx", "E", "E#", "F#", "Fx", "G", "G#", "Gx", "A", "A#", "Ax", "B", "B#"],
      "Cb" => ["Cb", "C", "Dbb", "Db", "D", "Ebb", "Eb", "Fb", "F", "Gbb", "Gb", "G", "Abb", "Ab", "A", "Bbb", "Bb"],
    }.deep_freeze
    MAJOR_DEGREES_MAP = {
      "C" => ALL_DEGREES.zip(MAJOR_DEGREES["C"]).to_h,
      "C#" => ALL_DEGREES.zip(MAJOR_DEGREES["C#"]).to_h,
      "Cb" => ALL_DEGREES.zip(MAJOR_DEGREES["Cb"]).to_h,
    }.deep_freeze

    MAJOR_MIDI_VALUES = MAJOR_DEGREES.transform_values do |note_names|
      note_names.map { |note_name| MidiNote.from_note(note_name, 3).midi_value }
    end.deep_freeze
    MAJOR_MIDI_VALUES_MAP = {
      "C" => ALL_DEGREES.zip(MAJOR_MIDI_VALUES["C"]).to_h,
      "C#" => ALL_DEGREES.zip(MAJOR_MIDI_VALUES["C#"]).to_h,
      "Cb" => ALL_DEGREES.zip(MAJOR_MIDI_VALUES["Cb"]).to_h,
    }.deep_freeze

    def test_root_midi_value
      NOTE_MIDI_VALUES.each do |note_args, midi_value|
        assert_equal(midi_value, Fet::Degrees.new(root_name: note_args[0], octave_value: note_args[1]).root_midi_value)
      end
    end

    def test_degree_names_of_midi_value
      MAJOR_MIDI_VALUES_MAP.each do |key_name, degrees_map|
        degrees_instance = Fet::Degrees.new(root_name: key_name, octave_value: 4)
        degrees_map.each do |degree_name, midi_value|
          assert_includes(degrees_instance.degree_names_of_midi_value(midi_value), degree_name)
        end
      end
    end

    def test_note_name_of_degree
      MAJOR_DEGREES_MAP.each do |key_name, degrees_map|
        degrees_instance = Fet::Degrees.new(root_name: key_name, octave_value: 4)
        degrees_map.each do |degree_name, note_name|
          assert_equal(note_name, degrees_instance.note_name_of_degree(degree_name))
        end
      end
    end
  end
end
