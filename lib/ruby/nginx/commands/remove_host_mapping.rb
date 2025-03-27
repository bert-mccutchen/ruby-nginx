# frozen_string_literal: true

require_relative "terminal_command"
require_relative "../system/os"

module Ruby
  module Nginx
    module Commands
      class RemoveHostMapping < TerminalCommand
        def initialize(host, ignore_ip: nil, sudo: false)
          @host = host
          @ignore_ip = ignore_ip
          @sudo = sudo
          @sudo_reason = "Allow sudo elevation to remove \"#{host}\" from /etc/hosts?"

          super(cmd: resolve_command, raise: Ruby::Nginx::ConfigError)
        end

        def run
          super unless removed?
        rescue Ruby::Nginx::ConfigError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(@host, ignore_ip: @ignore_ip, sudo: true).run
        end

        private

        def removed?
          hosts.each_line.none? do |host_config|
            host_config.include?(@host) && (@ignore_ip.nil? || !host_config.include?(@ignore_ip))
          end
        end

        def hosts
          @hosts ||= Ruby::Nginx::System::SafeFile.read("/etc/hosts")
        end

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
