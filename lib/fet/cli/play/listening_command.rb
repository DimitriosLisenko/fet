module Fet
  module Cli
    module Play
      module ListeningCommand
        def self.included(klass)
          klass.class_eval do
            desc("Run the ear training application")
            command(:play) do |c|
              c.desc("Run the ear training application for listening")
              c.long_desc("Each level will play a chord progression, followed by the specified number of degrees harmonically. The correct degrees should be selected.")
              c.command :listening do |listening|
                listening.desc("Tempo at which the chord progression is played at")
                listening.default_value(120)
                listening.flag([:t, :tempo], type: Integer)

                listening.desc("Number of degrees to play")
                listening.default_value(1)
                listening.flag([:d, :degrees], type: Integer, must_match: (1..11).map(&:to_s))

                listening.desc("Type of the chord progression")
                listening.default_value("major")
                listening.flag([:k, :"key-type"], type: String, must_match: ["major", "minor"])

                listening.desc("Automatically go to the next exercise when the answer was correct")
                listening.default_value(true)
                listening.switch [:n, :"next-on-correct"]

                listening.desc("Limit which degrees can play")
                listening.default_value([])
                listening.flag([:l, :"limit-degrees"], type: String, must_match: Fet::Degree::DEGREE_NAMES.flatten, multiple: true)

                listening.action do |global_options, options, args|
                  Fet::Cli::Play::Listening.run(global_options, options, args)
                end
              end
            end
          end
        end
      end
    end
  end
end
