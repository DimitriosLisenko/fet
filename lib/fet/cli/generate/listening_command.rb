module Fet
  module Cli
    module Generate
      module ListeningCommand
        def self.included(klass)
          klass.class_eval do
            desc("Generate MIDI files for ear training")
            command(:generate) do |c|
              c.desc("Generate MIDI files for listening")
              c.long_desc("Each MIDI file will contain a chord progression, followed by the specified number of degrees - first harmonically, then melodically after a pause.")
              c.command :listening do |listening|
                listening.desc("Tempo at which the chord progression is played at")
                listening.default_value(120)
                listening.flag([:t, :tempo], type: Integer)

                listening.desc("Number of degrees to play")
                listening.default_value(1)
                listening.flag([:d, :degrees], type: Integer, must_match: (1..11).map(&:to_s))

                listening.desc("Number of exercises to generate")
                listening.default_value(200)
                listening.flag([:e, :exercises], type: Integer)

                listening.desc("Generate all single degree listening exercises (ignores -e and -d flag)")
                listening.default_value(false)
                listening.switch [:a, :"all-single-degree"]

                listening.action do |global_options, options, args|
                  Fet::Cli::Generate::Listening.run(global_options, options, args)
                end
              end
            end
          end
        end
      end
    end
  end
end
