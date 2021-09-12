# frozen_string_literal: true

module Fet
  module Cli
    module Score
      # CLI implementation for the "score summary" command
      module Summary
        def self.run(_global_options, options, _args)
          Fet::ScoreSummary.new(
            minimum_session_length: options[:seconds],
            number_of_degrees: options[:degrees],
            key_type: options[:"key-type"],
            begin_offset: options[:"begin-offset"],
            end_offset: options[:"end-offset"],
          ).summary
        end
      end
    end
  end
end
