# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class RemoveHostMapping < TerminalCommand
        def initialize(host)
          cmd =
            if darwin?
              darwin_command(host)
            else
              linux_command(host)
            end

          super(cmd:, raise: Ruby::Nginx::ConfigError)
        end

        private

        def darwin_command(host)
          "sudo sed -i '' '/#{host}/d' /etc/hosts"
        end

        def linux_command(host)
          "sudo sed -i '/#{host}/d' /etc/hosts"
        end
      end
    end
  end
end
