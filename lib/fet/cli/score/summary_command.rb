module Fet
  module Cli
    module Score
      module SummaryCommand
        def self.included(klass)
          klass.class_eval do
            desc("Score commands")
            command(:score) do |c|
              c.desc("Show the score summary")
              c.command :summary do |summary|
                summary.desc("Only include games that had more playtime than the specified amount (seconds)")
                summary.default_value(0)
                summary.flag([:s, :seconds], type: Integer)

                summary.desc("Include games from this date onwards (YYYY/MM/DD)")
                summary.default_value(nil)
                summary.flag([:f, :"from-date"], type: DateTime)

                summary.desc("Include games prior to this date (YYYY/MM/DD)")
                summary.default_value(Date.today.to_s)
                summary.flag([:u, :"until-date"], type: DateTime)

                summary.action do |global_options, options, args|
                  Fet::Cli::Score::Summary.run(global_options, options, args)
                end
              end
            end
          end
        end
      end
    end
  end
end
