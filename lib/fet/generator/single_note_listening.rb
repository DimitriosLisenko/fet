# frozen_string_literal: true

module Fet
  module Generator
    # Class that generates MIDI files for the single note listening exercises
    class SingleNoteListening
      def initialize(tempo:)
        self.tempo = tempo
      end

      def generate; end

      private

      attr_accessor :tempo
    end
  end
end
