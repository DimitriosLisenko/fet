# frozen_string_literal: true

require "test_helper"

module Fet
  class NoteTest < Minitest::Test
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

    private

    def progressively_flattened_notes
      return ["Exxx", "E#xx", "Exx", "E#x", "Ex", "E#", "E", "Eb", "Ebb", "Ebbb"].map { |note_as_string| Note.new(note_as_string) }
    end
  end
end
