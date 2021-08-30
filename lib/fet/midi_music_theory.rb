# frozen_string_literal: true

require_relative "music_theory"

module Fet
  # Module in charge of handling music theory concepts as they translate to MIDI
  module MidiMusicTheory
    # In MIDI, the minimum note value is 0 (which is C(-1)) and the maximum note value is 127 (which is G(9))
    def self.note_midi_value(note_name, octave_number)
      c_midi_value = 12 * (1 + octave_number)
      result = c_midi_value + MusicTheory.semitones_from_c(note_name)
      raise InvalidMidiNote.new("#{note_name}#{octave_number}") if result.negative? || result > 127

      return result
    end

    # NOTE: This is not strictly correct because e.g. the midi value of 63 can be D#4 or Eb4, which affects
    # what degree it actually is. However, without additional information, this is good enough.
    def self.degree_from_midi_values(root_midi_value, note_midi_value)
      return (note_midi_value - root_midi_value) % 12
    end
  end
end
