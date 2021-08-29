# frozen_string_literal: true

require_relative "note"

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

    DEGREES_OF_MODE = {
      ["lydian"] => ["1", "2", "3", "#4", "5", "6", "7"],
      ["major", "ionian"] => ["1", "2", "3", "4", "5", "6", "7"],
      ["mixolydian"] => ["1", "2", "3", "4", "5", "6", "b7"],
      ["dorian"] => ["1", "2", "b3", "4", "5", "6", "b7"],
      ["minor", "aeolian"] => ["1", "2", "b3", "4", "5", "b6", "b7"],
      ["phrygian"] => ["1", "b2", "b3", "4", "5", "b6", "b7"],
      ["locrian"] => ["1", "b2", "b3", "4", "b5", "b6", "b7"],
    }.deep_freeze

    SEMITONES_FROM_C = {
      "C" => 0,
      "D" => 2,
      "E" => 4,
      "F" => 5,
      "G" => 7,
      "A" => 9,
      "B" => 11,
    }.deep_freeze

    # NOTE: returns value from 0 to 11
    def self.semitones_from_c(note_name)
      note = Note.new(note_name)
      return (SEMITONES_FROM_C[note.natural_note] + note.accidental_to_semitone_offset) % 12
    end

    def self.degrees_of_mode(mode_name)
      mode_info = DEGREES_OF_MODE.detect { |mode_names, _| mode_names.include?(mode_name) }
      raise InvalidModeName.new(mode_name) if mode_info.nil?

      return mode_info[1]
    end

    CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS = ["F", "C", "G", "D", "A", "E", "B"].deep_freeze
    CIRCLE_OF_FIFTHS = [
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| Note.new(note).flattened_note.flattened_note.flattened_note.full_note },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| Note.new(note).flattened_note.flattened_note.full_note },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| Note.new(note).flattened_note.full_note },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS,
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| Note.new(note).sharpened_note.full_note },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| Note.new(note).sharpened_note.sharpened_note.full_note },
      *CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.map { |note| Note.new(note).sharpened_note.sharpened_note.sharpened_note.full_note },
    ].deep_freeze

    ORDERED_NATURAL_NOTES = CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.sort.deep_freeze
    SEMITONES_TO_NEXT_NATURAL_NOTE = {
      "A" => 2,
      "B" => 1,
      "C" => 2,
      "D" => 2,
      "E" => 1,
      "F" => 2,
      "G" => 2,
    }.deep_freeze

    # A aeolian -> ["A", "B", "C", "D", "E", "F", "G"]
    def self.notes_of_mode(note_name, mode_name)
      relative_major_note_name = relative_major(note_name, mode_name)

      index = CIRCLE_OF_FIFTHS.index(relative_major_note_name)
      result = CIRCLE_OF_FIFTHS[(index - 1)..(index + 5)]
      raise UnsupportedRootName.new(note_name) unless result.size == 7

      result = result.sort
      return result.rotate(result.index(note_name))
    end

    # A aeolian -> C
    def self.relative_major(note_name, mode_name)
      note = Note.new(note_name)
      index = CIRCLE_OF_FIFTHS.index(note.full_note)
      raise UnsupportedRootName.new(note_name) if index.nil?

      result = CIRCLE_OF_FIFTHS[index - mode_offset_from_major(mode_name)]
      raise UnsupportedRootName.new(note_name) if result.nil?

      return result
    end

    class << self
      private

      def mode_offset_from_major(mode_name)
        MODES_IN_ORDER_OF_DARKNESS.each.with_index do |mode_names, index|
          return (index - 1) if mode_names.include?(mode_name)
        end
        raise InvalidModeName.new(mode_name)
      end
    end
  end
end
