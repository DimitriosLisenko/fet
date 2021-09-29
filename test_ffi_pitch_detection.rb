require "ffi"
require "wavefile"

# TODO: might have to do recording using ruby-portaudio gem???

WaveFile::Reader.new("./voice_mono.wav") do |reader|
  sample_rate = reader.native_format.sample_rate
  buffer_size = sample_rate / 10 # 0.1 seconds
  reader.each_buffer(buffer_size) do |buffer|
    samples = buffer.samples
    pointer = FFI::MemoryPointer.new(:double, samples.size)
    pointer.put_array_of_double(0, samples)
    frequency = Fet::PitchDetector.yin(pointer, samples.size, sample_rate)
    puts frequency
  end
end

#<WaveFile::Format:0x00007f9b9f03f5b0 @channels=1, @sample_format=:pcm, @bits_per_sample=32, @sample_rate=44100, @block_align=4, @byte_rate=176400, @speaker_mapping=[:front_center]>

require "wavefile"
# Fet::CommandRunner.run("cat voice_mono.wav") do |stdout, _, _| # OK WTF works???
# IO.popen("cat voice_mono.wav", external_encoding: "ASCII-8BIT") do |io|
  # stdout = File.open("voice_mono.wav") # works
  # Fet::CommandRunner.run("rec -c 1 -t wav - 2>/dev/null") do |stdout, _, _|
  # Fet::CommandRunner.run("rec -c 1 -t wav - 2>/dev/null | tee tee.wav") do |stdout, _, _|
  # stdout = File.open("voice_mono.wav") # works
  # IO.popen(["cat", "./voice_mono.wav"], "r+") do |stdout| # doesn't work
  # Fet::CommandRunner.run("cat voice_mono.wav") do |stdout, _, _| # doesn't work
# end


# File.open("aaa.wav") returns correct
# `cat aaa.wav` returns correct
# iopopen = IO.popen("cat aaa.wav") { |io| io.read } returns correct
require "wavefile"
# stdout = File.open("aaa.wav")
# File.open("aaa.wav") do |stdout|
# Fet::CommandRunner.run("cat aaa.wav") do |stdout, _, _|
# IO.popen("rec -c 1 -t wav test.wav 2>/dev/null") do |stdout|
# Fet::CommandRunner.run("rec -c 1 -t wav - 2>/dev/null") do |stdout, _, _|
wavefile_samples = []
require "wavefile"
stdout = File.open("correct.wav")
WaveFile::Reader.new(stdout) do |reader|
  sample_rate = reader.native_format.sample_rate
  buffer_size = sample_rate / 10
  reader.each_buffer(buffer_size) do |buffer|
    wavefile_samples << buffer.samples
    puts Fet::PitchDetector.frequency(buffer.samples, sample_rate)
  end
end
# end; nil

# Your stream is coming in as a pipe and that is not seekable. Since seek and pos won't work properly on a pipe you would have to read from the pipe.
# io_stream.read(number_of_bytes)

# Fet::CommandRunner.run("cat aaa.wav") { |io, _, _| puts io.size } => 0
IO.popen("cat aaa.wav") { |io| puts io.size }

# io_samples = []
# IO.popen("sox correct.wav -t s32 - 2>/dev/null") do |stdout|
IO.popen("rec -c 1 -t s32 - 2>/dev/null") do |stdout|
  sample_rate = 44100 # TODO: specify in the command line args to rec
  buffer_size = sample_rate / 10 # 0.1 seconds
  loop do
    samples = []
    buffer_size.times do
      break if stdout.eof?
      samples << stdout.read(4).unpack("l").first
    end
    # io_samples << samples
    puts Fet::PitchDetector.frequency(samples, sample_rate)
    break if stdout.eof?
  end
end

# x = nil; File.open("aaa.wav") { |io| x = io.read }; x.size
# => 88761
# 
# Fet::CommandRunner.run("cat aaa.wav") { |io| io.read.size }
# => 88972
# 
# IO.popen("cat aaa.wav") { |io| io.read.size }
# => 88761
# 
# `cat aaa.wav`.size
# => 88761
# 
# Open3.popen3("cat aaa.wav") { |_, io, _, _| puts io.read.size }
# => 88761
# 
# PTY.spawn("cat aaa.wav") { |io, _, _| puts io.read.size }

x = Fet::SoxInterface.new
x.start_recording
loop do
  frequency = x.read_frequency
  next if frequency < 0
  midi_value, cents = Fet::Frequency.frequency_to_midi_value(frequency)
  note_names = Fet::Degrees.new(root_name: "C", octave_value: 4).note_names_of_midi_value(midi_value)
  octave_number = Fet::MidiNote.new(midi_value).octave_number
  puts "#{note_names.join("/")} #{octave_number} #{cents} cents (#{frequency} Hz)"
end
