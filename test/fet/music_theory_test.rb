# frozen_string_literal: true

require "test_helper"

module Fet
  class MusicTheoryTest < Minitest::Test
    MAJOR_SCALES = [
      ["B", "C#", "D#", "E", "F#", "G#", "A#"],
      ["E", "F#", "G#", "A", "B", "C#", "D#"],
      ["A", "B", "C#", "D", "E", "F#", "G#"],
      ["D", "E", "F#", "G", "A", "B", "C#"],
      ["G", "A", "B", "C", "D", "E", "F#"],
      ["C", "D", "E", "F", "G", "A", "B"],
      ["F", "G", "A", "Bb", "C", "D", "E"],
      ["Bb", "C", "D", "Eb", "F", "G", "A"],
      ["Eb", "F", "G", "Ab", "Bb", "C", "D"],
      ["Ab", "Bb", "C", "Db", "Eb", "F", "G"],
      ["Db", "Eb", "F", "Gb", "Ab", "Bb", "C"],
      ["Gb", "Ab", "Bb", "Cb", "Db", "Eb", "F"],
    ].deep_freeze

    MINOR_SCALES = [
      ["G#", "A#", "B", "C#", "D#", "E", "F#"],
      ["C#", "D#", "E", "F#", "G#", "A", "B"],
      ["F#", "G#", "A", "B", "C#", "D", "E"],
      ["B", "C#", "D", "E", "F#", "G", "A"],
      ["E", "F#", "G", "A", "B", "C", "D"],
      ["A", "B", "C", "D", "E", "F", "G"],
      ["D", "E", "F", "G", "A", "Bb", "C"],
      ["G", "A", "Bb", "C", "D", "Eb", "F"],
      ["C", "D", "Eb", "F", "G", "Ab", "Bb"],
      ["F", "G", "Ab", "Bb", "C", "Db", "Eb"],
      ["Bb", "C", "Db", "Eb", "F", "Gb", "Ab"],
      ["Eb", "F", "Gb", "Ab", "Bb", "Cb", "Db"],
    ].deep_freeze

    def test_notes_of_major_scale
      MAJOR_SCALES.each do |major_scale|
        assert_equal(major_scale, Fet::MusicTheory.notes_of_mode(major_scale[0], "major"))
      end
    end

    def test_notes_of_minor_scale
      MINOR_SCALES.each do |minor_scale|
        assert_equal(minor_scale, Fet::MusicTheory.notes_of_mode(minor_scale[0], "minor"))
      end
    end

    def test_invalid_mode_name
      assert_raises(Fet::InvalidModeName) do
        Fet::MusicTheory.notes_of_mode("C", "doughnut")
      end
    end

    def test_invalid_root_name
      assert_raises(Fet::InvalidNote) do
        Fet::MusicTheory.notes_of_mode("H", "major")
      end
    end

    SEMITONES_FROM_C = {
      "C" => 0,
      "C#" => 1,
      "Db" => 1,
      "D" => 2,
      "D#" => 3,
      "Eb" => 3,
      "E" => 4,
      "F" => 5,
      "F#" => 6,
      "Gb" => 6,
      "G" => 7,
      "G#" => 8,
      "Ab" => 8,
      "A" => 9,
      "A#" => 10,
      "Bb" => 10,
      "B" => 11,
    }.deep_freeze

    def test_semitones_from_c
      SEMITONES_FROM_C.each do |note_name, semitones_from_c|
        assert_equal(semitones_from_c, Fet::MusicTheory.semitones_from_c(note_name))
      end
    end
  end
end
