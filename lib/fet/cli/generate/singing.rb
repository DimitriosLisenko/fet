# frozen_string_literal: true

module Fet
  module Cli
    module Generate
      # CLI implementation for the "generate singing" command
      module Singing
        def self.run(_global_options, options, _args)
          Fet::Generator::Singing.new(
            tempo: options[:tempo],
            pause: options[:pause],
            directory_prefix: options[:directory_prefix],
          ).generate
        end
      end
    end
  end
end
