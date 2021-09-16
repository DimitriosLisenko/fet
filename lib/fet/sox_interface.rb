# frozen_string_literal: true

require "open3"
require_relative "command_runner"

module Fet
  # Class responsible for interfacing with sox
  class SoxInterface
    # record audio (on default audio interface)
    # rec -t .wav output.wav
    # record and split audio into 0.5 second intervals
    # rec -t .wav output.wav trimmed_output.wav trim 0 0.5 : newfile : restart
    # split audio into 0.5 second intervals
    # sox output.wav trimmed_output.wav trim 0 0.5 : newfile : restart
    # analyze the frequencies
    # sox 1.wav -n stat
    # SOX: library for audio
    # LibSDL: library Ruby2D uses for audio, can record sound

    def self.rough_frequency_of_file(filename)
      _, result = CommandRunner.run("sox #{filename} -n stat")
      return result.split("\n")
                   .detect { |s| s.include?("Rough") && s.include?("frequency") }
                   .split(":")
                   .last.strip.to_i
    end
  end
end
