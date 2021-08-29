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

    # NOTE: performs the following conversions:
    # Fbb -> Fb -> F -> F# ->Fx -> F#x -> Fxx
    def sharpened_note
      note_as_string = case
                       when accidental.start_with?("b")
                         "#{natural_note}#{accidental[1..]}"
                       when accidental.start_with?("#")
                         "#{natural_note}x#{accidental[1..]}"
                       else
                         "#{natural_note}##{accidental}"
                       end

      return Note.new(note_as_string)
    end

    # NOTE: performs the following conversions:
    # Fxx -> F#x -> Fx -> F# -> F -> Fb -> Fbb
    def flattened_note
      note_as_string = case
                       when accidental.start_with?("x")
                         "#{natural_note}##{accidental[1..]}"
                       when accidental.start_with?("#")
                         "#{natural_note}#{accidental[1..]}"
                       else
                         "#{natural_note}#{accidental}b"
                       end

      return Note.new(note_as_string)
    end

    def accidental_to_semitone_offset
      case
      when accidental.start_with?("#")
        return 1 + 2 * accidental[1..].size
      when accidental.start_with?("x")
        return 2 * accidental[1..].size
      when accidental.start_with?("b")
        return -accidental.size
      else
        return 0
      end
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
