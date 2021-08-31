# frozen_string_literal: true

module Fet
  module Cli
    module Generate
      # CLI implementation for the "generate listening" command
      module Listening
        def self.run(_global_options, options, _args)
          Fet::Generator::Listening.new(
            exercises: options[:exercises],
            tempo: options[:tempo],
            degrees: options[:degrees],
          ).generate
        end
      end
    end
  end
end
