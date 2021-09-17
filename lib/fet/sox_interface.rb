# frozen_string_literal: true

require "open3"
require_relative "command_runner"

module Fet
  # Class responsible for interfacing with sox
  class SoxInterface
    def self.record_to_directory(directory = File.join(Fet.root, "tmp", "recording"), interval = "0.5")
      FileUtils.mkdir_p(directory)
      filename = File.join(directory, "output.wav")
      # NOTE: the file convention is that it starts with 001, goes to 999, and then continues normally (e.g. 1234)
      # TODO: see if this is configurable
      file_number = 1
      # TODO: recorded seems to randomly stop at some point, needs debugging
      CommandRunner.run_with_yield("rec -t .wav #{filename} trim 0 #{interval} : newfile : restart") do
        loop do
          filename = File.join(directory, "output#{format("%03d", file_number)}.wav")
          next_filename = File.join(directory, "output#{format("%03d", file_number + 1)}.wav")
          if File.exist?(next_filename)
            begin
              frequency = rough_frequency_of_file(filename)
              midi_value, cents = Fet::Frequency.frequency_to_midi_value(frequency)
              note_names = Fet::Degrees.new(root_name: "C", octave_value: 4).note_names_of_midi_value(midi_value)
              octave_number = Fet::MidiNote.new(midi_value).octave_number
              puts "#{note_names.join("/")} #{octave_number} #{cents} cents (#{frequency} Hz)"
            end
            file_number += 1
          else
            sleep(0.1)
          end
        end
      end
    end

    # TODO: "Rough frequency" doesn't seem to return the correct value, going to need to get the full frequency analysis via "sox ... -n stat -freq" and compute it
    def self.rough_frequency_of_file(filename)
      _, result = CommandRunner.run("sox #{filename} -n stat")
      return result.split("\n")
                   .detect { |s| s.include?("Rough") && s.include?("frequency") }
                   .split(":")
                   .last.strip.to_i
    end
  end
end
