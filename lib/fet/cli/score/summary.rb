# frozen_string_literal: true

module Fet
  module Cli
    module Score
      # CLI implementation for the "score summary" command
      module Summary
        def self.run(_global_options, options, _args)
          Fet::ScoreSummary.new(
            minimum_session_length: options[:seconds],
            date_from: options[:"from-date"],
            date_until: options[:"until-date"],
          ).summary
        end
      end
    end
  end
end
