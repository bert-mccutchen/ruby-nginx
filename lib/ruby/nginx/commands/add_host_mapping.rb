# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class AddHostMapping < TerminalCommand
        def initialize(host, ip, sudo: false)
          @host = host
          @ip = ip
          @sudo = sudo
          sudo_reason = "Allow sudo elevation to add \"#{host}\" to /etc/hosts?"

          super(
            cmd: "echo \"#{host_config}\" | #{sudoify("tee -a /etc/hosts", sudo, sudo_reason)}",
            raise: Ruby::Nginx::ConfigError
          )
        end

        def run
          super unless added?
        rescue Ruby::Nginx::ConfigError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(@host, @ip, sudo: true).run
        end

        private

        def added?
          hosts.include?(host_config)
        end

        def hosts
          @hosts ||= Ruby::Nginx::System::SafeFile.read("/etc/hosts")
        end

        def host_config
          "#{@ip} #{@host}"
        end
      end
    end
  end
end
