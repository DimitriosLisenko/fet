module Fet
  module Cli
    module Generate
      module SingingCommand
        def self.included(klass)
          klass.class_eval do
            command(:generate) do |c|
              c.desc("Generate MIDI files for singing")
              c.long_desc("Each MIDI file will contain a chord progression, followed by a specified pause, during which the degree should be sung."\
                          " The degree is then played for confirmation.")
              c.command :singing do |singing|
                singing.desc("Tempo at which the chord progression is played at")
                singing.default_value(120)
                singing.flag([:t, :tempo], type: Integer)

                singing.desc("How many seconds to wait before playing the correct note")
                singing.default_value(3)
                singing.flag([:p, :pause], type: Integer)

                singing.action do |global_options, options, args|
                  Fet::Cli::Generate::Singing.run(global_options, options, args)
                end
              end
            end
          end
        end
      end
    end
  end
end
