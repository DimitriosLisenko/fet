# frozen_string_literal: true

module Fet
  module Generator
    # Class that generates MIDI files for the singing exercises
    class Singing
      def initialize(tempo:, pause:)
        self.tempo = tempo
        self.pause = pause
      end

      def generate; end

      private

      attr_accessor :tempo, :pause
    end
  end
end
