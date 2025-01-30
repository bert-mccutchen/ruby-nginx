# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class AddHostMapping < TerminalCommand
        def initialize(host, ip)
          cmd = "echo \"#{ip} #{host}\" | sudo tee -a /etc/hosts"

          super(cmd:, raise: Ruby::Nginx::ConfigError)
        end
      end
    end
  end
end
