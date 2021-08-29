# frozen_string_literal: true

module Fet
  # Class responsible for parsing and validating musical notes from a string, e.g. "Eb"
  class Note
    attr_accessor :full_note,
                  :natural_note,
                  :accidental

    def initialize(note)
      self.full_note = note
      validate_full_note!

      self.natural_note = note[0]
      validate_natural_note!

      self.accidental = note[1..]
      validate_accidental!
    end

    private

    def validate_full_note!
      raise InvalidNote.new(full_note) unless full_note.is_a?(String)
    end

    def validate_natural_note!
      raise InvalidNote.new(full_note) unless natural_note.is_a?(String)
      raise InvalidNote.new(full_note) unless MusicTheory::CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.include?(natural_note)
    end

    def validate_accidental!
      raise InvalidNote.new(full_note) unless accidental.is_a?(String)

      unsharpened_accidental = accidental.delete_prefix("#")
      remaining_accidentals = unsharpened_accidental.chars.uniq
      if [0, 1].include?(remaining_accidentals.size)
        remaining_accidental = remaining_accidentals[0]
        return if [nil, "b", "#", "x"].include?(remaining_accidental)
      end

      raise InvalidNote.new(full_note)
    end
  end
end
