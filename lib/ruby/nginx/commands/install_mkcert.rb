# frozen_string_literal: true

require_relative "terminal_command"
require_relative "../system/os"

module Ruby
  module Nginx
    module Commands
      class InstallMkcert < TerminalCommand
        def initialize
          super(cmd: resolve_command, raise: Ruby::Nginx::InstallError, printer: :pretty)
        end

        def run
          return if installed?

          if yes?("Would you like to install mkcert?")
            super
          else
            raise Ruby::Nginx::AbortError, "mkcert is required to continue. Please install mkcert."
          end
        end

        private

        def installed?
          TTY::Command.new(printer: :null).run!("which mkcert").success?
        end

        def apt_get_command
          "sudo apt-get install -y libnss3-tools && " \
          "curl -L -C - \"https://dl.filippo.io/mkcert/latest?for=linux/amd64\" -o ./mkcert_download && " \
          "chmod +x ./mkcert_download && " \
          "sudo mv ./mkcert_download /usr/local/bin/mkcert"
        end

        def brew_command
          "brew install mkcert nss"
        end

        def pacman_command
          "sudo pacman -Syu nss mkcert"
        end

        def yum_command
          "sudo yum install -y nss-tools && " \
          "curl -L -C - \"https://dl.filippo.io/mkcert/latest?for=linux/amd64\" -o ./mkcert_download && " \
          "chmod +x ./mkcert_download && " \
          "sudo mv ./mkcert_download /usr/local/bin/mkcert"
        end

        def zypper_command
          "sudo zypper install -y mozilla-nss-tools && " \
          "curl -L -C - \"https://dl.filippo.io/mkcert/latest?for=linux/amd64\" -o ./mkcert_download && " \
          "chmod +x ./mkcert_download && " \
          "sudo mv ./mkcert_download /usr/local/bin/mkcert"
        end

        def resolve_command
          send("#{Ruby::Nginx::System::OS.instance.package_manager}_command")
        end
      end
    end
  end
end
