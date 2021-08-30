# frozen_string_literal: true

require_relative "music_theory"

module Fet
  # Class that handles MIDI values that represent notes
  class MidiNote
    attr_reader :midi_value

    def initialize(midi_value)
      self.midi_value = midi_value
      validate_midi_value!
    end

    def self.from_note(note_name, octave_number)
      midi_value_for_c = 12 * (1 + octave_number)
      midi_value = midi_value_for_c + MusicTheory.semitones_from_c(note_name)
      return new(midi_value)
    end

    def octave_number
      return (midi_value - 12) / 12
    end

    # NOTE: This is not strictly correct because e.g. the midi value of 63 can be D#4 or Eb4, which affects
    # what degree it actually is. However, without additional information, this is good enough.
    def degree(root_midi_value)
      return (midi_value - root_midi_value) % 12
    end

    private

    attr_writer :midi_value

    def validate_midi_value!
      # In MIDI, the minimum note value is 0 (which is C(-1)) and the maximum note value is 127 (which is G(9))
      raise InvalidMidiNote.new(midi_value) if midi_value.negative? || midi_value > 127
    end
  end
end
