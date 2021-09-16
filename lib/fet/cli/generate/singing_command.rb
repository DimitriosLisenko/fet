# frozen_string_literal: true

module Fet
  module Cli
    module Generate
      # Defines the CLI "generate singing" command
      module SingingCommand
        def self.included(klass)
          klass.class_eval do
            extend ClassMethods

            command(:generate) do |c|
              define_singing_command(c)
            end
          end
        end

        # Internal methods for the "generate singing" command
        module ClassMethods
          private

          def define_singing_command(command)
            command.desc("Generate MIDI files for singing")
            command.long_desc("Each MIDI file will contain a chord progression, followed by a specified pause, during which the degree should be sung."\
                              " The degree is then played for confirmation.")
            command.command :singing do |singing|
              define_tempo_flag(singing)
              define_pause_flag(singing)
              define_singing_action(singing)
            end
          end

          def define_tempo_flag(command)
            command.desc("Tempo at which the chord progression is played at")
            command.default_value(120)
            command.flag([:t, :tempo], type: Integer)
          end

          def define_pause_flag(command)
            command.desc("How many seconds to wait before playing the correct note")
            command.default_value(3)
            command.flag([:p, :pause], type: Integer)
          end

          def define_singing_action(command)
            command.action do |global_options, options, args|
              Fet::Cli::Generate::Singing.run(global_options, options, args)
            end
          end
        end
      end
    end
  end
end
