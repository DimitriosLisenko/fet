# frozen_string_literal: true

module Fet
  module Cli
    module Generate
      # Defines the CLI "generate listening" command
      module ListeningCommand
        def self.included(klass)
          klass.class_eval do
            klass.extend(ClassMethods)

            desc("Generate MIDI files for ear training")
            command(:generate) do |c|
              define_listening_command(c)
            end
          end
        end

        # Internal methods for the "generate listening" command
        module ClassMethods
          private

          def define_listening_command(command)
            command.desc("Generate MIDI files for listening")
            command.long_desc(long_listening_command_description)
            command.command :listening do |listening|
              define_tempo_flag(listening)
              define_degrees_flag(listening)
              define_exerises_flag(listening)
              define_all_single_degree_flag(listening)
              define_action(listening)
            end
          end

          def long_listening_command_description
            return "Each MIDI file will contain a chord progression, followed by the specified number of degrees - first harmonically, then melodically after a pause."
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

          def define_exerises_flag(command)
            command.desc("Number of exercises to generate")
            command.default_value(200)
            command.flag([:e, :exercises], type: Integer)
          end

          def define_all_single_degree_flag(command)
            command.desc("Generate all single degree listening exercises (ignores -e and -d flag)")
            command.default_value(false)
            command.switch [:a, :"all-single-degree"]
          end

          def define_action(command)
            command.action do |global_options, options, args|
              Fet::Cli::Generate::Listening.run(global_options, options, args)
            end
          end
        end
      end
    end
  end
end
