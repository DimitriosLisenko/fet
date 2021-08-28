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

    MODES_IN_ORDER_OF_DARKNESS = [
      ["lydian"],
      ["major", "ionian"],
      ["mixolydian"],
      ["dorian"],
      ["minor", "aeolian"],
      ["phrygian"],
      ["locrian"],
    ].deep_freeze

    # NOTE: performs the following conversions:
    # Fxx -> F#x -> Fx -> F# -> F -> Fb -> Fbb
    def self.flatten_note(note_name)
      root_name = note_name[0]
      accidental = note_name[1..]

      case
      when accidental.start_with?("x")
        return "#{root_name}##{accidental[1..]}"
      when accidental.start_with?("#")
        return "#{root_name}#{accidental[1..]}"
      else
        return "#{root_name}#{accidental}b"
      end
    end

    # NOTE: performs the following conversions:
    # Fbb -> Fb -> F -> F# ->Fx -> F#x -> Fxx
    def self.sharpen_note(note_name)
      root_name = note_name[0]
      accidental = note_name[1..]

      case
      when accidental.start_with?("b")
        return "#{root_name}#{accidental[1..]}"
      when accidental.start_with?("#")
        return "#{root_name}x#{accidental[1..]}"
      else
        return "#{root_name}##{accidental}"
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

    def self.mode_offset_from_major(mode_name)
      MODES_IN_ORDER_OF_DARKNESS.each.with_index do |mode_names, index|
        return (index - 1) if mode_names.include?(mode_name)
      end
      raise InvalidModeName.new(mode_name)
    end

    # A aeolian -> ["A", "B", "C", "D", "E", "F", "G"]
    def self.notes_of_mode(root_name, mode_name)
      relative_major_root_name = relative_major(root_name, mode_name)

      index = CIRCLE_OF_FIFTHS.index(relative_major_root_name)
      raise InvalidRootName.new(root_name) if index.nil?

      result = CIRCLE_OF_FIFTHS[(index - 1)..(index + 5)]
      raise UnsupportedRootName.new(root_name) unless result.size == 7

      result = result.sort
      return result.rotate(result.index(root_name))
    end

    # A aeolian -> C
    def self.relative_major(root_name, mode_name)
      index = CIRCLE_OF_FIFTHS.index(root_name)
      raise InvalidRootName.new(root_name) if index.nil?

      result = CIRCLE_OF_FIFTHS[index - mode_offset_from_major(mode_name)]
      raise UnsupportedRootName.new(root_name) if result.nil?

      return result
    end
  end
end
