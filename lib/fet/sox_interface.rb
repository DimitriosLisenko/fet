# frozen_string_literal: true

require_relative "command_runner"

# NOTE: https://stackoverflow.com/questions/15031544/extract-fast-fourier-transform-data-from-file - alternative fourier transform

module Fet
  # Class responsible for interfacing with sox
  class SoxInterface
    def initialize
      self.frequency_queue = Queue.new
      self.recording_thread = nil
    end

    def read_frequency
      return frequency_queue.pop
    end

    def start_recording
      Thread.abort_on_exception = true
      self.recording_thread = Thread.new do
        CommandRunner.run("rec -c 1 -t wav - 2>/dev/null | sox -t .wav - -n stat -freq") do |stdout, _, pid|
          loop do
            frequency_queue.push(calculate_frequency(stdout))
          end
        end
      end
    end

    private

    attr_accessor :frequency_queue, :recording_thread

    def calculate_frequency(io)
      strongest_frequency = 0.0
      strongest_power = 0.0
      loop do
        frequency_bin, power = io.gets.split.map(&:to_f)
        if power > strongest_power
          strongest_frequency = frequency_bin
          strongest_power = power
        end
        break if (frequency_bin - "22039.234375".to_f).abs < Float::EPSILON
      end
      return strongest_frequency
    end

    # midi_value, cents = Fet::Frequency.frequency_to_midi_value(frequency)
    # note_names = Fet::Degrees.new(root_name: "C", octave_value: 4).note_names_of_midi_value(midi_value)
    # octave_number = Fet::MidiNote.new(midi_value).octave_number
    # puts "#{note_names.join("/")} #{octave_number} #{cents} cents (#{frequency} Hz)"

    # def self.rough_frequency_of_file(filename)
    #   _, result, _ = Open3.capture3("sox #{filename} -n stat -freq")
    #   return result.split("\n")
    #                .reject { |s| s.include?(":") }
    #                .map { |s| s.split.map(&:to_f) }
    #                .reject { |arr| arr[1] < 2000 }
    #                .reduce(Hash.new(0)) { |res, arr| res[arr[0]] += arr[1]; res }
    #                .max_by { |_, v| v }&.dig(0)
    # end
  end
end
