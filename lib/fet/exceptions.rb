# frozen_string_literal: true

module Fet
  class Error < StandardError; end

  class InvalidNote < Error; end

  class InvalidModeName < Error; end

  # TODO: this can be removed if the circle of fifths is generated dynamically
  class UnsupportedRootName < Error; end
end
