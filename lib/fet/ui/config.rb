# frozen_string_literal: true

require "tmpdir"

module Fet
  module Ui
    # This class is responsible for holding the configuration for the game passed in by the user via a file/flags.
    class Config
      ATTRIBUTES_TO_DEFAULT_VALUE = {
        note_range: Fet::REDUCED_BY_OCTAVE_PIANO_RANGE,
        tmp_directory: Dir.mktmpdir,
        tempo: 120,
        number_of_degrees: 1,
        key_type: "major",
        next_on_correct: true,
        limit_degrees: [],
        limit_keys: [],
        internal_range: nil,
      }.deep_freeze

      attr_accessor(*ATTRIBUTES_TO_DEFAULT_VALUE.keys)

      def initialize(flags:)
        ATTRIBUTES_TO_DEFAULT_VALUE.each do |attribute, default_value|
          send("#{attribute}=", default_value)
        end
        override_from_flags(flags)
      end

      def override_from_flags(flags)
        self.tempo = flags[:tempo]
        self.number_of_degrees = flags[:degrees]
        self.key_type = flags[:"key-type"]
        self.next_on_correct = flags[:"next-on-correct"]
        self.limit_degrees = flags[:"limit-degrees"]
        self.internal_range = flags[:"question-range"]
        self.limit_keys = ["C"]
      end
    end
  end
end
