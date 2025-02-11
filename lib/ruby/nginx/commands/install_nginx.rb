# frozen_string_literal: true

require_relative "terminal_command"
require_relative "../system/os"

module Ruby
  module Nginx
    module Commands
      class InstallNginx < TerminalCommand
        def initialize
          super(cmd: resolve_command, raise: Ruby::Nginx::InstallError, printer: :pretty)
        end

        def run
          return if installed?

          puts "\e[0;33m#{cmd}\e[0m"

          if yes?("Would you like to install NGINX?")
            super
          else
            raise Ruby::Nginx::AbortError, "NGINX is required to continue. Please install NGINX."
          end
        end

        private

        def installed?
          TTY::Command.new(printer: :null).run!("which nginx").success?
        end

        def apt_get_command
          "sudo apt-get install -y nginx"
        end

        def pacman_command
          "sudo pacman -Syu nginx"
        end

        def brew_command
          "brew install nginx"
        end

        def yum_command
          "sudo yum install -y nginx"
        end

        def zypper_command
          "sudo zypper install -y nginx"
        end

        def resolve_command
          send("#{Ruby::Nginx::System::OS.instance.package_manager}_command")
        end
      end
    end
  end
end
