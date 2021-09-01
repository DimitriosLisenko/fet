# frozen_string_literal: true

module Fet
  module TestHelpers
    module HardcodedMidiValues
      NOTE_MIDI_VALUES = {
        ["C", 0] => 12,
        ["C", 1] => 24,
        ["C", 2] => 36,
        ["C", 3] => 48,
        ["C", 4] => 60,
        ["C", 5] => 72,
        ["C", 6] => 84,
        ["G#", 6] => 92,
        ["Ab", 6] => 92,
        ["Gx", 6] => 93,
        ["A", 6] => 93,
        ["Bbb", 6] => 93,
        ["A#", 6] => 94,
        ["Bb", 6] => 94,
        ["C", 7] => 96,
        ["C", 8] => 108,
        ["C", 9] => 120,
      }.deep_freeze
    end
  end
end
