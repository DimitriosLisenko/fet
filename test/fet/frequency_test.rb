# frozen_string_literal: true

require "test_helper"

module Fet
  class DegreesTest < Minitest::Test
    # https://en.wikipedia.org/wiki/Scientific_pitch_notation
    FREQUENCY_TO_MIDI_VALUE = {
      16.35160 => 12,
      17.32391 => 13,
      18.35405 => 14,
      19.44544 => 15,
      20.60172 => 16,
      21.82676 => 17,
      23.12465 => 18,
      24.49971 => 19,
      25.95654 => 20,
      27.50000 => 21,
      29.13524 => 22,
      30.86771 => 23,
      32.70320 => 24,
      34.64783 => 25,
      36.70810 => 26,
      38.89087 => 27,
      41.20344 => 28,
      43.65353 => 29,
      46.24930 => 30,
      48.99943 => 31,
      51.91309 => 32,
      55.00000 => 33,
      58.27047 => 34,
      61.73541 => 35,
      65.40639 => 36,
      69.29566 => 37,
      73.41619 => 38,
      77.78175 => 39,
      82.40689 => 40,
      87.30706 => 41,
      92.49861 => 42,
      97.99886 => 43,
      103.8262 => 44,
      110.0000 => 45,
      116.5409 => 46,
      123.4708 => 47,
      130.8128 => 48,
      138.5913 => 49,
      146.8324 => 50,
      155.5635 => 51,
      164.8138 => 52,
      174.6141 => 53,
      184.9972 => 54,
      195.9977 => 55,
      207.6523 => 56,
      220.0000 => 57,
      233.0819 => 58,
      246.9417 => 59,
      261.6256 => 60,
      277.1826 => 61,
      293.6648 => 62,
      311.1270 => 63,
      329.6276 => 64,
      349.2282 => 65,
      369.9944 => 66,
      391.9954 => 67,
      415.3047 => 68,
      440.0000 => 69,
      466.1638 => 70,
      493.8833 => 71,
      523.2511 => 72,
      554.3653 => 73,
      587.3295 => 74,
      622.2540 => 75,
      659.2551 => 76,
      698.4565 => 77,
      739.9888 => 78,
      783.9909 => 79,
      830.6094 => 80,
      880.0000 => 81,
      932.3275 => 82,
      987.7666 => 83,
      1046.502 => 84,
      1108.731 => 85,
      1174.659 => 86,
      1244.508 => 87,
      1318.510 => 88,
      1396.913 => 89,
      1479.978 => 90,
      1567.982 => 91,
      1661.219 => 92,
      1760.000 => 93,
      1864.655 => 94,
      1975.533 => 95,
      2093.005 => 96,
      2217.461 => 97,
      2349.318 => 98,
      2489.016 => 99,
      2637.020 => 100,
      2793.826 => 101,
      2959.955 => 102,
      3135.963 => 103,
      3322.438 => 104,
      3520.000 => 105,
      3729.310 => 106,
      3951.066 => 107,
      4186.009 => 108,
      4434.922 => 109,
      4698.636 => 110,
      4978.032 => 111,
      5274.041 => 112,
      5587.652 => 113,
      5919.911 => 114,
      6271.927 => 115,
      6644.875 => 116,
      7040.000 => 117,
      7458.620 => 118,
      7902.133 => 119,
      8372.018 => 120,
      8869.844 => 121,
      9397.273 => 122,
      9956.063 => 123,
      10_548.08 => 124,
      11_175.30 => 125,
      11_839.82 => 126,
      12_543.85 => 127,
    }.deep_freeze

    def test_frequency_to_midi_note
      FREQUENCY_TO_MIDI_VALUE.each do |frequency, correct_midi_value|
        midi_value, cents = Frequency.frequency_to_midi_value(frequency)
        assert_equal(correct_midi_value, midi_value, "Frequency: #{frequency}")
        assert_equal(0, cents, "Frequency: #{frequency}")
      end
    end

    def test_frequency_logarithms
      Fet::Frequency::FREQUENCY_LOGARITHMS.each_cons(2) do |lower, higher|
        assert_equal(Rational(1, 1), higher - lower)
      end
    end

    def test_frequency_to_midi_note_boundary
      assert_frequency_midi_value(4065.0, 107, 49) # both implementations agree it should round to 49
      assert_frequency_midi_value(4066.0, 108, -50) # both implementations agree it should round to -50
      assert_frequency_midi_value(4067.0, 108, -50) # both implementations agree it should round to -50
      assert_frequency_midi_value(450.0, 69, 39)
      assert_frequency_midi_value(11_000.0, 125, -27)
    end

    def test_with_alternative_implementation
      (700..200_000).each do |val|
        frequency = val / 10.0
        midi_value, cents = Frequency.frequency_to_midi_value(frequency)
        alternative_midi_value, alternative_cents = alternative_cents_implementation(frequency)
        assert_at_most_cent_difference(midi_value, alternative_midi_value, cents, alternative_cents, "Frequency: #{frequency}")
      end
    end

    private

    def assert_frequency_midi_value(frequency, expected_midi_value, expected_cents)
      midi_value, cents = Frequency.frequency_to_midi_value(frequency)
      assert_equal(midi_value, expected_midi_value)
      assert_equal(cents, expected_cents)
    end

    def assert_at_most_cent_difference(midi_value, alternative_midi_value, cents, alternative_cents, msg = nil)
      acceptable_values = [
        decrease_by_cent(midi_value, cents),
        [midi_value, cents],
        increase_by_cent(midi_value, cents),
      ]
      assert_includes(acceptable_values, [alternative_midi_value, alternative_cents], msg)
    end

    def decrease_by_cent(midi_value, cents)
      cents -= 1
      if cents == -51
        midi_value -= 1
        cents += 100
      end

      return midi_value, cents
    end

    def increase_by_cent(midi_value, cents)
      cents += 1
      if cents == 50
        midi_value += 1
        cents -= 100
      end

      return midi_value, cents
    end

    def alternative_cents_implementation(frequency)
      frequency_above_index = Fet::Frequency::FREQUENCIES.index { |f| f > frequency }
      frequency_below_index = frequency_above_index - 1

      frequency_below = Fet::Frequency::FREQUENCIES[frequency_below_index]
      frequency_above = Fet::Frequency::FREQUENCIES[frequency_above_index]

      frequency_below_cents = cents_difference(frequency, frequency_below)
      frequency_above_cents = cents_difference(frequency, frequency_above)

      return Fet::Frequency::MIDI_VALUES[frequency_below_index], frequency_below_cents if frequency_below_cents >= -50 && frequency_below_cents <= 49
      return Fet::Frequency::MIDI_VALUES[frequency_above_index], frequency_above_cents if frequency_above_cents >= -50 && frequency_above_cents <= 49

      raise "Invalid value for cents"
    end

    # The formula to calculate the cents difference between two known frequencies: 1200 * log2(f1, f2)
    # REFERENCE: https://en.wikipedia.org/wiki/Cent_(music)
    def cents_difference(frequency, known_frequency)
      return (1200.0 * Math.log(frequency / known_frequency, 2)).round
    end
  end
end
