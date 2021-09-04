# frozen_string_literal: true

module Fet
  module Cli
    module Play
      # CLI implementation for the "play listening" command
      module Listening
        def self.run(_global_options, options, _args)
          Fet::Ui::Game.new(
            tempo: options[:tempo],
            degrees: options[:degrees],
            key_type: options[:"key-type"],
          ).start
        end
      end
    end
  end
end
