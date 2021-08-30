# frozen_string_literal: true

require "test_helper"
require_relative "test_helpers/hardcoded_scales"

module Fet
  class MusicTheoryTest < Minitest::Test
    include TestHelpers::HardcodedScales

    def test_notes_of_major_scale
      hardcoded_scales("major").each do |major_scale|
        assert_equal(major_scale, Fet::MusicTheory.notes_of_mode(major_scale[0], "major"))
      end
    end

    def test_notes_of_minor_scale
      hardcoded_scales("minor").each do |minor_scale|
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
      "Gbbbb" => 3,
      "E" => 4,
      "Gbbb" => 4,
      "F" => 5,
      "Gbb" => 5,
      "F#" => 6,
      "Gb" => 6,
      "Fx" => 7,
      "G" => 7,
      "F#x" => 8,
      "G#" => 8,
      "Ab" => 8,
      "Fxx" => 9,
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
