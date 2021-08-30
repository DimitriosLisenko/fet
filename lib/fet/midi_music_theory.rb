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
  end
end
