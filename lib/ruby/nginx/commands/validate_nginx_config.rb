# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class ValidateNginxConfig < TerminalCommand
        def initialize
          super(cmd: "sudo nginx -t", raise: Ruby::Nginx::ConfigError)
        end
      end
    end
  end
end
