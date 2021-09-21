# frozen_string_literal: true

# nm -gU /usr/local/lib/libpitch_detection.so
# https://github.com/ffi/ffi/issues/554
# OK so probably there's gonna be an intermediate layer of converting a C array to a C++ vector before calling the method???
# https://stackoverflow.com/questions/32904417/how-to-wrap-stdvector-of-custom-structure-with-ffi
# https://stackoverflow.com/questions/29389334/how-do-i-handle-ruby-arrays-in-ruby-ffi-gem
# => do it in the C++ code and recompile the binary???

require "ffi"

module Fet
  class PitchAnalyzer
    extend FFI::Library

    ffi_lib("/Users/dima/programming/pitch-detection/lib/libpitch_detection.so")

    attach_function :yin, "_ZN5pitch3yinEPKdmi", [:pointer, :size_t, :int], :double

    def self.frequency(samples, sample_rate)
      pointer = FFI::MemoryPointer.new(:double, samples.size)
      pointer.put_array_of_double(0, samples)
      return yin(pointer, samples.size, sample_rate)
    end
  end
end
