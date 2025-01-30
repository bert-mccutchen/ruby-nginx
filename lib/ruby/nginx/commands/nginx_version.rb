# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class NginxVersion < TerminalCommand
        def initialize
          super(cmd: "nginx -v", raise: Ruby::Nginx::Error)
        end

        def run
          super

          # nginx -v outputs to stderr
          Ruby::Nginx::Version.new(result.stderr.match(/\d+\.\d+\.?\d?/).to_s)
        end
      end
    end
  end
end
