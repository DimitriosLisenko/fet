# frozen_string_literal: true

require_relative "midi_note"

module Fet
  MAJOR_ROOT_MIDI_VALUES = {
    "C#" => MidiNote.from_note("C#", 4).midi_value,
    "F#" => MidiNote.from_note("F#", 3).midi_value,
    "B" => MidiNote.from_note("B", 3).midi_value,
    "E" => MidiNote.from_note("E", 3).midi_value,
    "A" => MidiNote.from_note("A", 3).midi_value,
    "D" => MidiNote.from_note("D", 4).midi_value,
    "G" => MidiNote.from_note("G", 3).midi_value,
    "C" => MidiNote.from_note("C", 4).midi_value,
    "F" => MidiNote.from_note("F", 3).midi_value,
    "Bb" => MidiNote.from_note("Bb", 3).midi_value,
    "Eb" => MidiNote.from_note("Eb", 4).midi_value,
    "Ab" => MidiNote.from_note("Ab", 3).midi_value,
    "Db" => MidiNote.from_note("Db", 4).midi_value,
    "Gb" => MidiNote.from_note("Gb", 3).midi_value,
    "Cb" => MidiNote.from_note("Cb", 3).midi_value,
  }.deep_freeze
  MINOR_ROOT_MIDI_VALUES = MusicTheory::MINOR_KEYS.zip(MAJOR_ROOT_MIDI_VALUES.values.map { |i| i - 3 }).to_h.deep_freeze
end
