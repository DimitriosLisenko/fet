# frozen_string_literal: true

require_relative "midi_note"

module Fet
  # Class responsible for calculating frequencies of a note and vice versa
  class Frequency
    # REFERENCE: https://en.wikipedia.org/wiki/Piano_key_frequencies
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

    MIDI_VALUES = MIDI_VALUE_TO_FREQUENCY.keys.deep_freeze
    FREQUENCIES = MIDI_VALUE_TO_FREQUENCY.values.deep_freeze

    # NOTE: this divides the frequencies into equal buckets with distance of 1 between them
    # NOTE: round to 3 decimal places: we only care about dividing notes into 100 equal buckets, additional decimal place allows for rounding
    # REFERENCE: https://en.wikipedia.org/wiki/Equal_temperament
    TWELFTH_ROOT_OF_TWO = 2 ** (1.0 / 12.0)
    def self.frequency_to_bucket_value(frequency)
      rounded_value = Math.log(frequency, TWELFTH_ROOT_OF_TWO).round(3)
      return Rational((rounded_value * 1000).round, 1000)
    end

    FREQUENCY_LOGARITHMS = FREQUENCIES.map do |frequency|
      frequency_to_bucket_value(frequency)
    end.deep_freeze

    # This function returns the frequency of the given midi value, e.g 123
    def self.midi_value_to_frequency(midi_value)
      return MIDI_VALUE_TO_FREQUENCY[midi_value]
    end

    # This function returns the frequency of the given note, e.g. E8
    def self.note_to_frequency(note_name, octave_number)
      return midi_value_to_frequency(MidiNote.from_note(note_name, octave_number).midi_value)
    end

    # This function returns:
    # 1) the midi value the frequency represents and
    # 2) the offset (in cents) for the given frequency in range [-50, 50)
    def self.frequency_to_midi_value(frequency)
      frequency_bucket_value = frequency_to_bucket_value(frequency)
      difference = frequency_bucket_value - FREQUENCY_LOGARITHMS[0]
      midi_index = difference.round
      cents = ((difference - midi_index) * 100).round
      midi_value = MIDI_VALUES[midi_index]
      if cents == 50
        midi_value += 1
        cents -= 100
      end
      return midi_value, cents
    end
  end
end
