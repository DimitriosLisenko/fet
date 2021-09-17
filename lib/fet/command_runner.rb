# frozen_string_literal: true

require "open3"

module Fet
  # Class responsible for running external commands
  class CommandRunner
    def self.run(command)
      Open3.popen3(command) do |_, stdout, stderr, wait_thr|
        # wait for the process to finish running
        exit_status = wait_thr.value
        stdout_value = stdout.read
        stderr_value = stderr.read
        raise CommandRunFailed.new("Failed command: #{command}: #{stderr_value}") unless exit_status.success?

        return [stdout_value, stderr_value]
      end
    end

    def self.run_with_yield(command)
      stdin, stdout, stderr, wait_thr = Open3.popen3(command)
      yield [stdin, stdout, stderr, wait_thr]
    ensure
      stdin.close
      stdout.close
      stderr.close
      Process.kill("TERM", wait_thr.pid)
      exit_status = wait_thr.value
      raise CommandRunFailed.new("Failed command: #{command}: #{stderr.read}") unless exit_status.success?
    end
  end
end
