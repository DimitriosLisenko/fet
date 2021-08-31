# frozen_string_literal: true

module Fet
  module Generator
    # Class that generates MIDI files for the listening exercises
    class Listening
      def initialize(exercises:, tempo:, degrees:)
        self.exercises = exercises
        self.tempo = tempo
        self.degrees = degrees
      end

      def generate; end

      private

      attr_accessor :exercises, :tempo, :degrees
    end
  end
end
