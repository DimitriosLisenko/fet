# frozen_string_literal: true

module Fet
  # Class responsible for parsing and validating musical notes from a string, e.g. "Eb"
  class Note
    ACCIDENTAL_TO_SEMITONES_MAP = {
      "b" => -1,
      "#" => 1,
      "x" => 2,
    }.deep_freeze

    # TODO: this class could also potentially handle the octave number - note that e.g. Bb,B,Bx... are in octave 3 while Cb,C,C# are in octave 4
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

    def self.accidental_from_semitone_offset(semitone_offset)
      return "" if semitone_offset.zero?
      return "b" * -semitone_offset if semitone_offset.negative?

      number_of_hashes = (semitone_offset % 2).zero? ? 0 : 1
      number_of_xs = semitone_offset / 2
      return "#" * number_of_hashes + "x" * number_of_xs
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

    # NOTE: normalizing the note means:
    # - converting the natural note + accidentals such that the remaining accidental is either "b", "", or "#", or
    # - if a note name is provided, then convert the accidental such that the natural note matches the pitch of the original
    def normalized_note
      remaining_semitones = accidental_to_semitone_offset
      next_note = remaining_semitones.positive? ? next_natural_note : previous_natural_note
      next_note_offset = remaining_semitones.positive? ? semitone_offset_to_next_natural_note : semitone_offset_to_previous_natural_note
      return Note.new(full_note) if next_note_offset.abs > remaining_semitones.abs

      return Note.new("#{next_note}#{self.class.accidental_from_semitone_offset(remaining_semitones - next_note_offset)}").normalized_note
    end

    # TODO: do
    def change_natural_note(new_natural_note)
      semitone_offset = accidental_to_semitone_offset
      return Note.new("#{natural_note}#{self.class.accidental_from_semitone_offset(semitone_offset)}") if new_natural_note == natural_note
    end

    # TODO: create a diatonic scale class and move it there
    def degree(root_name)
      notes_array = Fet::MusicTheory.notes_of_mode(root_name, "major")
      index = notes_array.index { |note| Note.new(note).natural_note == natural_note }

      degree = index + 1
      degree_note = Note.new(notes_array[index])

      # TODO: normalized_note(natural_note).accidental_to_semitone_offset - degree_note.normalized_accidental(degree_note.natural_note).accidental_to_semitone_offset
      accidental_difference = accidental_to_semitone_offset - degree_note.accidental_to_semitone_offset
      return "#{self.class.accidental_from_semitone_offset(accidental_difference)}#{degree}"
    end

    def accidental_to_semitone_offset
      return accidental.chars.map { |char| ACCIDENTAL_TO_SEMITONES_MAP[char] }.sum
    end

    def natural?
      return accidental.chars.empty?
    end

    def flattened?
      return accidental.chars.include?("b")
    end

    def sharpened?
      return accidental.chars.include?("#") || accidental.chars.include?("x")
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

    def normalized_accidental
      normalized_offset = accidental_to_semitone_offset.abs % 12
      normalized_offset = -normalized_offset if accidental_to_semitone_offset.negative?
      return self.class.accidental_from_semitone_offset(normalized_offset)
    end

    def next_natural_note
      index = Fet::MusicTheory::ORDERED_NATURAL_NOTES.index(natural_note)
      index = (index + 1) % Fet::MusicTheory::ORDERED_NATURAL_NOTES.size
      return Fet::MusicTheory::ORDERED_NATURAL_NOTES[index]
    end

    def previous_natural_note
      index = Fet::MusicTheory::ORDERED_NATURAL_NOTES.index(natural_note)
      index = (index - 1) % Fet::MusicTheory::ORDERED_NATURAL_NOTES.size
      return Fet::MusicTheory::ORDERED_NATURAL_NOTES[index]
    end

    def semitone_offset_to_next_natural_note
      return Fet::MusicTheory::SEMITONES_TO_NEXT_NATURAL_NOTE[natural_note]
    end

    def semitone_offset_to_previous_natural_note
      return -Fet::MusicTheory::SEMITONES_TO_NEXT_NATURAL_NOTE[previous_natural_note]
    end
  end
end
