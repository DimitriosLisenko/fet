# frozen_string_literal: true

module Fet
  module Cli
    module Play
      # CLI implementation for the "play listening" command
      module Listening
        def self.run(_global_options, options, _args)
          Fet::Ui::Game.new(
            config: Fet::Ui::Config.new(flags: options)
          ).start
        end
      end
    end
  end
end
