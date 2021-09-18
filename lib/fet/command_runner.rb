# frozen_string_literal: true

require "pty"

module Fet
  # Class responsible for running external commands
  class CommandRunner
    # REFERENCE: https://stackoverflow.com/questions/1154846/continuously-read-from-stdout-of-external-process-in-ruby
    # REFERENCE: https://stackoverflow.com/questions/43208040/ruby-continuously-output-stdout-of-a-long-running-shell-command
    # REFERENCE: https://stackoverflow.com/questions/7212573/when-to-use-each-method-of-launching-a-subprocess-in-ruby
    def self.run(command)
      PTY.spawn(command) do |stdout, stdin, pid|
        yield stdout, stdin, pid
      ensure
        Process.kill("TERM", pid)
      end
    end
  end
end
