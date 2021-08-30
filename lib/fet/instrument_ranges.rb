# frozen_string_literal: true

require_relative "midi_music_theory"

module Fet
  PIANO_RANGE = (MidiMusicTheory.note_midi_value("A", 0)..MidiMusicTheory.note_midi_value("C", 8)).to_a.deep_freeze
  REDUCED_BY_OCTAVE_PIANO_RANGE = (MidiMusicTheory.note_midi_value("A", 1)..MidiMusicTheory.note_midi_value("C", 7)).to_a.deep_freeze
  GUITAR_RANGE = (MidiMusicTheory.note_midi_value("E", 2)..MidiMusicTheory.note_midi_value("E", 6)).to_a.deep_freeze
  # Ranges according to Wikipedia:
  # Bass: E2 - E4
  # Baritone: G2 - G4
  # Tenor: C3 - C5
  # Countertenor: E3 - E5
  # Contralto: F3 - F5
  # Mezzo-soprano: A3 - A5
  # Soprano: C4 - C6
  LOW_SINGING_OCTAVE_RANGE = (MidiMusicTheory.note_midi_value("D", 3)...MidiMusicTheory.note_midi_value("D", 4)).to_a.deep_freeze
  HIGH_SINGING_OCTAVE_RANGE = (MidiMusicTheory.note_midi_value("D", 4)...MidiMusicTheory.note_midi_value("D", 5)).to_a.deep_freeze
end
