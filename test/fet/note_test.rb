# frozen_string_literal: true

require "test_helper"
require_relative "hardcoded_scales"

module Fet
  class NoteTest < Minitest::Test
    include HardcodedScales

    def test_flatten_note
      progressively_flattened_notes.each_cons(2) do |sharpened_note, flattened_note|
        assert_equal(flattened_note.full_note, sharpened_note.flattened_note.full_note)
      end
    end

    def test_sharpen_note
      progressively_flattened_notes.each_cons(2) do |sharpened_note, flattened_note|
        assert_equal(sharpened_note.full_note, flattened_note.sharpened_note.full_note)
      end
    end

    def test_sharpen_followed_by_flatten
      progressively_flattened_notes.each do |note|
        assert_equal(note.full_note, note.sharpened_note.flattened_note.full_note)
      end
    end

    def test_flatten_followed_by_sharpen
      progressively_flattened_notes.each do |note|
        assert_equal(note.full_note, note.flattened_note.sharpened_note.full_note)
      end
    end

    def test_invalid_accidentals
      assert_raises(InvalidNote) { Note.new("E##") }
      assert_raises(InvalidNote) { Note.new("Ex#") }
      assert_raises(InvalidNote) { Note.new("Eb#") }
      assert_raises(InvalidNote) { Note.new("E#b") }
      assert_raises(InvalidNote) { Note.new("E#xxb") }
      assert_raises(InvalidNote) { Note.new("Ej") }
      assert_raises(InvalidNote) { Note.new("Ebd") }
      assert_raises(InvalidNote) { Note.new("Edb") }
    end

    def test_invalid_natural_notes
      assert_raises(InvalidNote) { Note.new("H") }
      assert_raises(InvalidNote) { Note.new("c#") }
      assert_raises(InvalidNote) { Note.new("Ubb") }
    end

    def test_invalid_types
      assert_raises(InvalidNote) { Note.new(nil) }
      assert_raises(InvalidNote) { Note.new(Note.new("C")) }
      assert_raises(InvalidNote) { Note.new(0) }
    end

    def test_accidental_from_semitone_offset
      assert_equal("bbb", Fet::Note.accidental_from_semitone_offset(-3))
      assert_equal("bb", Fet::Note.accidental_from_semitone_offset(-2))
      assert_equal("b", Fet::Note.accidental_from_semitone_offset(-1))
      assert_equal("", Fet::Note.accidental_from_semitone_offset(0))
      assert_equal("#", Fet::Note.accidental_from_semitone_offset(1))
      assert_equal("x", Fet::Note.accidental_from_semitone_offset(2))
      assert_equal("#x", Fet::Note.accidental_from_semitone_offset(3))
      assert_equal("xx", Fet::Note.accidental_from_semitone_offset(4))
      assert_equal("#xx", Fet::Note.accidental_from_semitone_offset(5))
      assert_equal("xxx", Fet::Note.accidental_from_semitone_offset(6))
    end

    def test_major_scale_degrees
      MAJOR_SCALES.each do |major_scale|
        degrees = major_scale.map do |major_scale_note|
          Note.new(major_scale_note).degree(major_scale[0])
        end
        assert_equal(degrees_of_major_scale, degrees)
      end
    end

    def test_minor_scale_degrees
      MINOR_SCALES.each do |minor_scale|
        degrees = minor_scale.map do |minor_scale_note|
          Note.new(minor_scale_note).degree(minor_scale[0])
        end
        assert_equal(degrees_of_minor_scale, degrees)
      end
    end

    private

    def progressively_flattened_notes
      return ["Exxx", "E#xx", "Exx", "E#x", "Ex", "E#", "E", "Eb", "Ebb", "Ebbb"].map { |note_as_string| Note.new(note_as_string) }
    end

    def degrees_of_major_scale
      ["1", "2", "3", "4", "5", "6", "7"]
    end

    def degrees_of_minor_scale
      ["1", "2", "b3", "4", "5", "b6", "b7"]
    end
  end
end
