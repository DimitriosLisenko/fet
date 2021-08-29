# frozen_string_literal: true

module Fet
  class Error < StandardError; end

  class InvalidNote < Error; end

  class InvalidRootName < Error; end

  class InvalidModeName < Error; end

  class UnsupportedRootName < Error; end
end
