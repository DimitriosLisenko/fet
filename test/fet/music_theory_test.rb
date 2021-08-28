# frozen_string_literal: true

require "test_helper"

module Fet
  class MusicTheoryTest < Minitest::Test
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

    private

    def progressively_flattened_notes
      return ["Exxx", "E#xx", "Exx", "E#x", "Ex", "E#", "E", "Eb", "Ebb", "Ebbb"]
    end
  end
end
