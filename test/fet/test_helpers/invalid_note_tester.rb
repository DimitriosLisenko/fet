# frozen_string_literal: true

module Fet
  module TestHelpers
    module InvalidNoteTester
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
    end
  end
end
