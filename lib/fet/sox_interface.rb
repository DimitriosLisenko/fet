# frozen_string_literal: true

module Fet
  # Class responsible for interfacing with sox
  class SoxInterface
    def initialize
      self.frequency_queue = Queue.new
      self.recording_thread = nil
      self.sample_rate = 44_100
      # NOTE: analyze 0.1 seconds
      self.buffer_size = sample_rate / 10
    end

    def read_frequency
      return frequency_queue.pop
    end

    def start_recording
      Thread.abort_on_exception = true
      self.recording_thread = Thread.new do
        # NOTE: Record with 44.1K sample rate (-r) to a single mono channel (-c) and output
        #       the amplitudes of the wave file as 32-bit signed integers (-t) to STDOUT (-)
        #       and disregard STDERR. Mono recording is required for pitch detection to work.
        # REFERENCE: https://stackoverflow.com/questions/1154846/continuously-read-from-stdout-of-external-process-in-ruby
        # REFERENCE: https://stackoverflow.com/questions/43208040/ruby-continuously-output-stdout-of-a-long-running-shell-command
        # REFERENCE: https://stackoverflow.com/questions/7212573/when-to-use-each-method-of-launching-a-subprocess-in-ruby
        # REFERENCE: https://stackoverflow.com/questions/42541588/any-way-i-can-get-sox-to-just-print-the-amplitude-values-from-a-wav-file
        # NOTE: PTY.spawn doesn't work because it converts \n to \r\n for some reason, which is bad when outputting a binary file.
        IO.popen("rec -r #{sample_rate} -c 1 -t s32 - 2>/dev/null") do |stdout|
          loop do
            frequency_queue.push(calculate_frequency(stdout))
            # break if stdout.eof?
          end
        end
      end
    end

    private

    attr_accessor :frequency_queue, :recording_thread, :sample_rate, :buffer_size

    def calculate_frequency(io)
      # NOTE: I originally wanted to use the "wavefile" gem to analyze the wav file; however, it doesn't work with pipes because it uses
      #       IO#seek (doesn't work on pipes). So instead going to manually extract the amplitude values.
      samples = []
      buffer_size.times do
        # break if io.eof?
        # NOTE: unpacking with "l" means converting a string that looks like "\x00\xdf\xa0..." to "32-bit signed, native endian (int32_t)"
        samples << io.read(4).unpack1("l")
      end
      result = Fet::PitchAnalyzer.frequency(samples, sample_rate)
      result = filter_frequency_by_range(result)
      result = filter_frequency_by_amplitude(result, samples)
      return result
    end

    def filter_frequency_by_range(frequency)
      return nil if frequency.nil?
      return nil if frequency < 80 || frequency > 1100

      return frequency
    end

    # TODO: convert to dB
    def filter_frequency_by_amplitude(frequency, samples)
      return nil if samples.min.abs < 80_000_000
      return nil if samples.max.abs < 80_000_000

      return frequency
    end
  end
end
