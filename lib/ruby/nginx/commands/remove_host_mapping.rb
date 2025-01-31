# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class RemoveHostMapping < TerminalCommand
        def initialize(host, sudo: false)
          @host = host
          @sudo = sudo
          cmd =
            if darwin?
              darwin_command
            else
              linux_command
            end

          super(cmd:, raise: Ruby::Nginx::ConfigError)
        end

        def run
          super
        rescue Ruby::Nginx::ConfigError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(@host, sudo: true).run
        end

        private

        def darwin_command
          sudoify("sed -i '' '/#{@host}/d' /etc/hosts", @sudo)
        end

        def linux_command
          sudoify("sed -i '/#{@host}/d' /etc/hosts", @sudo)
        end
      end
    end
  end
end
