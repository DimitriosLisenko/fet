module Fet
  module Cli
    module Generate
      module SingleNoteListeningCommand
        def self.included(klass)
          klass.class_eval do
            command(:generate) do |c|
              c.desc("Generate MIDI files for listening (single note)")
              c.long_desc("Each MIDI file will contain a chord progression, followed the same note across all files.")
              c.command :single_note_listening do |single_note_listening|
                single_note_listening.desc("Tempo at which the chord progression is played at")
                single_note_listening.default_value(120)
                single_note_listening.flag([:t, :tempo], type: Integer)

                single_note_listening.action do |global_options, options, args|
                  Fet::Cli::Generate::SingleNoteListening.run(global_options, options, args)
                end
              end
            end
          end
        end
      end
    end
  end
end
