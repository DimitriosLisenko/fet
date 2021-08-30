# frozen_string_literal: true

require_relative "midi_note"

module Fet
  PIANO_RANGE = (MidiNote.from_note("A", 0).midi_value..MidiNote.from_note("C", 8).midi_value).to_a.deep_freeze
  REDUCED_BY_OCTAVE_PIANO_RANGE = (MidiNote.from_note("A", 1).midi_value..MidiNote.from_note("C", 7).midi_value).to_a.deep_freeze
  GUITAR_RANGE = (MidiNote.from_note("E", 2).midi_value..MidiNote.from_note("E", 6).midi_value).to_a.deep_freeze
  # Ranges according to Wikipedia:
  # Bass: E2 - E4
  # Baritone: G2 - G4
  # Tenor: C3 - C5
  # Countertenor: E3 - E5
  # Contralto: F3 - F5
  # Mezzo-soprano: A3 - A5
  # Soprano: C4 - C6
  LOW_SINGING_OCTAVE_RANGE = (MidiNote.from_note("D", 3).midi_value...MidiNote.from_note("D", 4).midi_value).to_a.deep_freeze
  HIGH_SINGING_OCTAVE_RANGE = (MidiNote.from_note("D", 4).midi_value...MidiNote.from_note("D", 5).midi_value).to_a.deep_freeze
end
