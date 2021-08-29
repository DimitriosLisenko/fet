# frozen_string_literal: true

module Fet
  # Class responsible for parsing and validating musical notes from a string, e.g. "Eb"
  class Note
    attr_accessor :original_note,
                  :natural_note,
                  :accidental

    def initialize(note)
      self.original_note = note
      validate_original_note!(note)

      self.natural_note = note[0]
      validate_natural_note!

      self.accidental = note[1..]
      validate_accidental!
    end

    private

    def validate_original_note!
      raise InvalidNote.new(original_note) unless original_note.is_a?(String)
    end

    def validate_natural_note!
      raise InvalidNote.new(original_note) unless natural_note.is_a?(String)
      raise InvalidNote.new(original_note) unless MusicTheory::CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.include?(natural_note)
    end

    def validate_accidental!
      raise InvalidNote.new(original_note) unless accidental.is_a?(String)

      return if accidental.empty?
      return if accidental.start_with?("#") && accidental[1..].chars.uniq == ["x"]
      return if accidental.start_with?("x") && accidental.chars.uniq == ["x"]
      return if accidental.start_with?("b") && accidental.chars.uniq == ["b"]

      raise InvalidNote.new(original_note)
    end
  end
end
