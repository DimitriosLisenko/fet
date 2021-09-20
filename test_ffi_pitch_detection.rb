require "ffi"
require "wavefile"

reader = WaveFile::Reader.new("./voice_mono.wav")
sample_rate = reader.native_format.sample_rate
buffer_size = sample_rate / 10 # 0.1 seconds
reader.each_buffer(buffer_size) do |buffer|
  samples = buffer.samples
  pointer = FFI::MemoryPointer.new(:double, samples.size)
  pointer.put_array_of_double(0, samples)
  frequency = Fet::PitchAnalyzer.yin(pointer, samples.size, sample_rate)
  puts frequency
end
