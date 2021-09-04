# frozen_string_literal: true

module Fet
  class Error < StandardError; end

  class InvalidNote < Error; end

  class InvalidChordProgression < Error; end

  class InvalidModeName < Error; end

  class InvalidMidiNote < Error; end

  class InvalidDegreeName < Error; end

  class InvalidCustomEventType < Error; end

  # TODO: this can be removed if the circle of fifths is generated dynamically
  class UnsupportedRootName < Error; end
end
