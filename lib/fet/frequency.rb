# frozen_string_literal: true

require_relative "midi_note"

module Fet
  # Class responsible for calculating frequencies of a note and vice versa
  class Frequency
    # Reference: https://en.wikipedia.org/wiki/Piano_key_frequencies
    ZEROTH_OCTAVE_MIDI_VALUE_TO_FREQUENCY = {
      MidiNote.from_note("C", 0).midi_value => 16.35160,
      MidiNote.from_note("Db", 0).midi_value => 17.32391,
      MidiNote.from_note("D", 0).midi_value => 18.35405,
      MidiNote.from_note("Eb", 0).midi_value => 19.44544,
      MidiNote.from_note("E", 0).midi_value => 20.60172,
      MidiNote.from_note("F", 0).midi_value => 21.82676,
      MidiNote.from_note("Gb", 0).midi_value => 23.12465,
      MidiNote.from_note("G", 0).midi_value => 24.49971,
      MidiNote.from_note("Ab", 0).midi_value => 25.95654,
      MidiNote.from_note("A", 0).midi_value => 27.50000,
      MidiNote.from_note("Bb", 0).midi_value => 29.13524,
      MidiNote.from_note("B", 0).midi_value => 30.86771,
    }.deep_freeze

    # NOTE: the frequency of a note an octave above is 2 times the frequency of the octave below
    MIDI_VALUE_TO_FREQUENCY = (0..10).map do |octave_number|
      ZEROTH_OCTAVE_MIDI_VALUE_TO_FREQUENCY.map do |midi_value, frequency|
        [midi_value + (12 * octave_number), frequency * (2 ** octave_number)]
      end
    end.flatten(1).to_h.deep_freeze

    FREQUENCY_TO_MIDI_VALUE = MIDI_VALUE_TO_FREQUENCY.invert.deep_freeze

    # NOTE: this divides the frequencies into equal buckets with distance of 1 between them
    # https://en.wikipedia.org/wiki/Equal_temperament
    # NOTE: round to 2 decimal places because we only care about dividing notes into 100 equal buckets
    TWELFTH_ROOT_OF_TWO = 2 ** (1.0 / 12.0)
    def self.frequency_to_bucket_value(frequency)
      return Math.log(frequency, TWELFTH_ROOT_OF_TWO).round(2)
    end

    FREQUENCY_LOGARITHMS = MIDI_VALUE_TO_FREQUENCY.values.map do |frequency|
      frequency_to_bucket_value(frequency)
    end.deep_freeze

    # returns the frequency of the given midi value
    def self.midi_value_to_frequency(note_name, octave_number)
      return MIDI_VALUE_TO_FREQUENCY[MidiNote.from_note(note_name, octave_number).midi_value]
    end

    # returns the midi value and offset (in cents) for the given frequency
    def self.frequency_to_midi_value(frequency)
      # frequency_bucket_value = frequency_to_bucket_value(frequency)
    end
  end
end
