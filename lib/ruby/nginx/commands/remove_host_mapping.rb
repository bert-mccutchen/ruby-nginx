# frozen_string_literal: true

require_relative "terminal_command"
require_relative "../system/os"

module Ruby
  module Nginx
    module Commands
      class RemoveHostMapping < TerminalCommand
        def initialize(host, sudo: false)
          @host = host
          @sudo = sudo
          @sudo_reason = "Allow sudo elevation to remove \"#{host}\" from /etc/hosts?"

          super(cmd: resolve_command, raise: Ruby::Nginx::ConfigError)
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
          sudoify("sed -i '' '/#{@host}/d' /etc/hosts", @sudo, @sudo_reason)
        end

        def linux_command
          sudoify("sed -i '/#{@host}/d' /etc/hosts", @sudo, @sudo_reason)
        end

        def resolve_command
          if Ruby::Nginx::System::OS.instance.darwin?
            darwin_command
          else
            linux_command
          end
        end
      end
    end
  end
end
