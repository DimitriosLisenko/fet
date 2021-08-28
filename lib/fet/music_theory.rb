# frozen_string_literal: true

module Fet
  # Module in charge of handling music theory concepts
  module MusicTheory
    # All 12 degrees
    DEGREES = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "b6", "6", "b7", "7"].deep_freeze

    # All keys. First element is 5 sharps, 4 sharps, ... 0 sharps/flats, 1 flat, ... all the way up to 6 flats.
    # No 6 sharps because the 6 flat versions are enharmonic and more common.
    # These keys chosen because they contain only flats and sharps, no double flats/sharps.
    MAJOR_KEYS = ["B", "E", "A", "D", "G", "C", "F", "Bb", "Eb", "Ab", "Db", "Gb"].deep_freeze
    MINOR_KEYS = ["G#", "C#", "F#", "B", "E", "A", "D", "G", "C", "F", "Bb", "Eb"].deep_freeze

    # NOTE: performs the following conversions:
    # Fxx -> F#x -> Fx -> F# -> F -> Fb -> Fbb
    def self.flatten_note(full_note_name)
      note_name = full_note_name[0]
      accidental = full_note_name[1..]

      case
      when accidental.start_with?("x")
        return "#{note_name}##{accidental[1..]}"
      when accidental.start_with?("#")
        return "#{note_name}#{accidental[1..]}"
      else
        return "#{note_name}#{accidental}b"
      end
    end

    # NOTE: performs the following conversions:
    # Fbb -> Fb -> F -> F# ->Fx -> F#x -> Fxx
    def self.sharpen_note(full_note_name)
      note_name = full_note_name[0]
      accidental = full_note_name[1..]

      case
      when accidental.start_with?("b")
        return "#{note_name}#{accidental[1..]}"
      when accidental.start_with?("#")
        return "#{note_name}x#{accidental[1..]}"
      else
        return "#{note_name}##{accidental}"
      end
    end

    CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS = ["F", "C", "G", "D", "A", "E", "B"].deep_freeze
    CIRCLE_OF_FIFTHS = [
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| flatten_note(flatten_note(flatten_note(note))) },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| flatten_note(flatten_note(note)) },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| flatten_note(note) },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS,
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| sharpen_note(note) },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| sharpen_note(sharpen_note(note)) },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| sharpen_note(sharpen_note(sharpen_note(note))) },
    ].deep_freeze

    def self.notes_of_major_scale(root_name)
      return notes_of_scale(root_name, -1, 5)
    end

    def self.notes_of_minor_scale(root_name)
      return notes_of_scale(root_name, -4, 2)
    end

    class << self
      private

      def notes_of_scale(root_name, left_offset, right_offset)
        index = CIRCLE_OF_FIFTHS.index(root_name)
        raise InvalidRootName.new(root_name) if index.nil?

        result = CIRCLE_OF_FIFTHS[(index + left_offset)..(index + right_offset)]
        raise UnsupportedRootName.new(root_name) unless result.size == 7

        result = result.sort
        return result.rotate(result.index(root_name))
      end
    end
  end
end
