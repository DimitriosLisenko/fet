# frozen_string_literal: true

module Fet
  # Module holding validations for the Note class
  module NoteValidations
    private

    def validate_full_note!
      raise InvalidNote.new(full_note) unless full_note.is_a?(String)
    end

    def validate_natural_note!
      raise InvalidNote.new(full_note) unless natural_note.is_a?(String)
      raise InvalidNote.new(full_note) unless MusicTheory::CIRCLE_OF_FIFTHS_WITHOUT_ACCIDENTALS.include?(natural_note)
    end

    def validate_accidental!
      raise InvalidNote.new(full_note) unless valid_accidental_type?
      return if accidental.empty?

      raise InvalidNote.new(full_note) unless valid_accidental_logic?
    end

    def valid_accidental_type?
      return accidental.is_a?(String)
    end

    def valid_accidental_logic?
      return false unless valid_accidental_characters?
      return false if can_be_flat_accidental? && !valid_flat_accidental?
      return false if can_be_sharp_accidental? && !valid_sharp_accidental?

      return true
    end

    def valid_accidental_characters?
      return accidental.chars.uniq.all? { |char| ["b", "#", "x"].include?(char) }
    end

    def can_be_flat_accidental?
      return accidental.chars.uniq.include?("b")
    end

    def valid_flat_accidental?
      return accidental.chars.uniq.all? { |char| ["b"].include?(char) } # there can only be "b" characters
    end

    def can_be_sharp_accidental?
      return accidental.chars.uniq.include?("#") || accidental.chars.uniq.include?("x")
    end

    def valid_sharp_accidental?
      return accidental.chars.uniq.all? { |char| ["#", "x"].include?(char) } && # only allow "#" and "x" characters
             [0, 1].include?(accidental.chars.select { |char| char == "#" }.size) && # there can be at most one "#" character
             accidental.chars.sort.join == accidental # the "#" character must come before any "x" characters
    end
  end
end
