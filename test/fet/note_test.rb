# frozen_string_literal: true

require "test_helper"
require_relative "test_helpers/hardcoded_scales"
require_relative "test_helpers/invalid_note_tester"

module Fet
  class NoteTest < Minitest::Test
    include TestHelpers::HardcodedScales
    include TestHelpers::InvalidNoteTester

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

    OFFSET_TO_ACCIDENTAL_HASH = {
      -3 => "bbb",
      -2 => "bb",
      -1 => "b",
      0 => "",
      1 => "#",
      2 => "x",
      3 => "#x",
      4 => "xx",
      5 => "#xx",
      6 => "xxx",
    }.deep_freeze

    def test_accidental_from_semitone_offset
      OFFSET_TO_ACCIDENTAL_HASH.each do |offset, accidental|
        assert_equal(accidental, Fet::Note.accidental_from_semitone_offset(offset))
      end
    end

    def test_scale_degrees
      Fet::MusicTheory::MODES_IN_ORDER_OF_DARKNESS.flatten.each do |mode_name|
        hardcoded_scales(mode_name).each do |scale|
          degrees = scale.map do |scale_note|
            Note.new(scale_note).degree(scale[0])
          end
          assert_equal(Fet::MusicTheory.degrees_of_mode(mode_name), degrees)
        end
      end
    end

    NOTE_TO_NORMALIZED_NOTE_HASH = {
      "G" => "G",
      "Fb" => "E",
      "E#" => "F",
      "Cb" => "B",
      "B#" => "C",
      "Gx" => "A",
      "Abb" => "G",
      "Gxxxxxx" => "G",
      "G#xxxxxx" => "G#",
      "Gxxxxxxx" => "A",
      "Gbbbbbbbbbbbb" => "G",
      "Gbbbbbbbbbbbbb" => "Gb",
      "Gbbbbbbbbbbbbbb" => "F",
    }.deep_freeze

    def test_normalized_note
      NOTE_TO_NORMALIZED_NOTE_HASH.each do |note, normalized_note|
        assert_equal(normalized_note, Note.new(note).normalized_note.full_note)
      end
    end

    def test_note_natural
      assert(Note.new("C").natural?)
      assert(!Note.new("C").flattened?)
      assert(!Note.new("C").sharpened?)
    end

    def test_note_flattened
      assert(!Note.new("Cb").natural?)
      assert(Note.new("Cb").flattened?)
      assert(!Note.new("Cb").sharpened?)
    end

    def test_note_sharp
      assert(!Note.new("C#").natural?)
      assert(!Note.new("C#").flattened?)
      assert(Note.new("C#").sharpened?)
    end

    def test_another_note_sharp
      assert(!Note.new("Cx").natural?)
      assert(!Note.new("Cx").flattened?)
      assert(Note.new("Cx").sharpened?)
    end

    private

    def progressively_flattened_notes
      return ["Exxx", "E#xx", "Exx", "E#x", "Ex", "E#", "E", "Eb", "Ebb", "Ebbb"].map { |note_as_string| Note.new(note_as_string) }
    end
  end
end
