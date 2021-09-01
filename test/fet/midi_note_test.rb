# frozen_string_literal: true

require "test_helper"
require_relative "test_helpers/hardcoded_midi_values"

module Fet
  class MidiNoteTest < Minitest::Test
    include TestHelpers::HardcodedMidiValues

    NOTE_TO_DEGREE_RELATIVE_TO_C = {
      ["C", 2] => 0,
      ["C#", 2] => 1,
      ["Db", 2] => 1,
      ["D", 2] => 2,
      ["D#", 2] => 3,
      ["Eb", 2] => 3,
      ["E", 2] => 4,
      ["F", 2] => 5,
      ["F#", 2] => 6,
      ["Gb", 2] => 6,
      ["G", 2] => 7,
      ["G#", 2] => 8,
      ["Ab", 2] => 8,
      ["A", 2] => 9,
      ["A#", 2] => 10,
      ["Bb", 2] => 10,
      ["B", 2] => 11,
      ["C", 3] => 0,
    }.deep_freeze

    def test_note_midi_value
      NOTE_MIDI_VALUES.each do |note_array, midi_value|
        assert_equal(midi_value, MidiNote.from_note(*note_array).midi_value)
      end
    end

    def test_note_octave_value
      NOTE_MIDI_VALUES.each do |note_array, _|
        assert_equal(note_array[1], MidiNote.from_note(*note_array).octave_number)
      end
    end

    def test_note_degree
      NOTE_TO_DEGREE_RELATIVE_TO_C.each do |note_array, degree|
        assert_equal(degree, MidiNote.from_note(*note_array).degree(MidiNote.from_note("C", 2).midi_value))
      end
    end

    def test_invalid_midi_value
      assert_raises(InvalidMidiNote) { MidiNote.new(-1) }
      assert_raises(InvalidMidiNote) { MidiNote.new(128) }
    end
  end
end
