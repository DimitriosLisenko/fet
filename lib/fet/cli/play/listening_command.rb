# frozen_string_literal: true

module Fet
  module Cli
    module Play
      # Defines the CLI "play listening" command
      module ListeningCommand
        def self.included(klass)
          klass.class_eval do
            extend ClassMethods

            desc("Run the ear training application")
            command(:play) do |c|
              define_listening_command(c)
            end
          end
        end

        # Internal methods for the "play listening" command
        module ClassMethods
          private

          def define_listening_command(command)
            command.desc("Run the ear training application for listening")
            command.long_desc("Each level will play a chord progression, followed by the specified number of degrees harmonically. The correct degrees should be selected.")
            command.command :listening do |listening|
              define_tempo_flag(listening)
              define_degrees_flag(listening)
              define_key_type_flag(listening)
              define_next_on_correct_flag(listening)
              define_limit_degrees_flag(listening)

              define_listening_action(listening)
            end
          end

          def define_tempo_flag(command)
            command.desc("Tempo at which the chord progression is played at")
            command.default_value(120)
            command.flag([:t, :tempo], type: Integer)
          end

          def define_degrees_flag(command)
            command.desc("Number of degrees to play")
            command.default_value(1)
            command.flag([:d, :degrees], type: Integer, must_match: (1..11).map(&:to_s))
          end

          def define_key_type_flag(command)
            command.desc("Type of the chord progression")
            command.default_value("major")
            command.flag([:k, :"key-type"], type: String, must_match: ["major", "minor"])
          end

          def define_next_on_correct_flag(command)
            command.desc("Automatically go to the next exercise when the answer was correct")
            command.default_value(true)
            command.switch [:n, :"next-on-correct"]
          end

          def define_limit_degrees_flag(command)
            command.desc("Limit which degrees can play")
            command.default_value([])
            command.flag([:l, :"limit-degrees"], type: String, must_match: Fet::Degree::DEGREE_NAMES.flatten, multiple: true)
          end

          def define_listening_action(command)
            command.action do |global_options, options, args|
              Fet::Cli::Play::Listening.run(global_options, options, args)
            end
          end
        end
      end
    end
  end
end
