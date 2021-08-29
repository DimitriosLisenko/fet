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

    def test_flatten_note
      progressively_flattened_notes.each_cons(2) do |sharpened_note, flattened_note|
        assert_equal(flattened_note, Fet::MusicTheory.flatten_note(sharpened_note))
      end
    end

    def test_sharpen_note
      progressively_flattened_notes.each_cons(2) do |sharpened_note, flattened_note|
        assert_equal(sharpened_note, Fet::MusicTheory.sharpen_note(flattened_note))
      end
    end

    def test_sharpen_followed_by_flatten
      progressively_flattened_notes.each do |note|
        assert_equal(note, Fet::MusicTheory.flatten_note(Fet::MusicTheory.sharpen_note(note)))
      end
    end

    def test_flatten_followed_by_sharpen
      progressively_flattened_notes.each do |note|
        assert_equal(note, Fet::MusicTheory.sharpen_note(Fet::MusicTheory.flatten_note(note)))
      end
    end

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

    private

    def progressively_flattened_notes
      return ["Exxx", "E#xx", "Exx", "E#x", "Ex", "E#", "E", "Eb", "Ebb", "Ebbb"]
    end
  end
end
