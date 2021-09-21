# frozen_string_literal: true

# NOTE: To attach function, you need to know its symbol, which can be determined like so:
#       nm -gU /usr/local/lib/libpitch_detection.so (or whatever shared library object)
# Other references:
# https://github.com/ffi/ffi/issues/554
# https://stackoverflow.com/questions/32904417/how-to-wrap-stdvector-of-custom-structure-with-ffi
# https://stackoverflow.com/questions/29389334/how-do-i-handle-ruby-arrays-in-ruby-ffi-gem

require "ffi"

module Fet
  class PitchAnalyzer
    extend FFI::Library

    # NOTE: passing array will load one of them or fail - use to provide .so and .dylib
    # TODO: perhaps delay ffi_lib call until it is required (which is only during the singing exercises),
    #       otherwise if the user doesn't have the required dependencies for this library, it will fail to even run the console
    ffi_lib([File.join(Fet.root, "ext", "fet", "libpitch_detection.dylib")])

    attach_function :yin, "_ZN5pitch3yinEPKdmi", [:pointer, :size_t, :int], :double

    def self.frequency(samples, sample_rate)
      FFI::MemoryPointer.new(:double, samples.size) do |pointer|
        pointer.put_array_of_double(0, samples)
        return yin(pointer, samples.size, sample_rate)
      end
    end
  end
end
