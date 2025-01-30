# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class StopNginx < TerminalCommand
        def initialize
          super(cmd: "nginx -s stop", raise: Ruby::Nginx::StopError)
        end

        def run
          super
        rescue Ruby::Nginx::StopError => e
          # Nginx is not running - ignore.
          raise unless e.message.include?("invalid PID number")
        end
      end
    end
  end
end
