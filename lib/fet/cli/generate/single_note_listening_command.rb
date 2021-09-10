# frozen_string_literal: true

module Fet
  module Cli
    module Generate
      # Defines the CLI "generate single_note_listening" command
      module SingleNoteListeningCommand
        def self.included(klass)
          klass.class_eval do
            klass.extend(ClassMethods)

            command(:generate) do |c|
              define_single_note_listening_command(c)
            end
          end
        end

        # Internal methods for the "generate single_note_listening" command
        module ClassMethods
          private

          def define_single_note_listening_command(command)
            command.desc("Generate MIDI files for listening (single note)")
            command.long_desc("Each MIDI file will contain a chord progression, followed the same note across all files.")
            command.command :single_note_listening do |single_note_listening|
              define_tempo_flag(single_note_listening)
              define_single_note_listening_action(single_note_listening)
            end
          end

          def define_tempo_flag(command)
            command.desc("Tempo at which the chord progression is played at")
            command.default_value(120)
            command.flag([:t, :tempo], type: Integer)
          end

          def define_single_note_listening_action(command)
            command.action do |global_options, options, args|
              Fet::Cli::Generate::SingleNoteListening.run(global_options, options, args)
            end
          end
        end
      end
    end
  end
end
