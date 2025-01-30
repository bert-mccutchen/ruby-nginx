# frozen_string_literal: true

require "singleton"
require "tty/command"

module Ruby
  module Nginx
    module Commands
      class TerminalCommand
        attr_reader :cmd, :user, :error_type, :result

        def initialize(cmd:, user: nil, raise: nil)
          @cmd = cmd
          @user = user
          @error_type = raise
          @result = nil
        end

        def run
          @result = TTY::Command.new.run(cmd, user: user)
          raise @error_type, @result.err if error_type && @result.failure?

          @result
        end

        protected

        def darwin?
          RbConfig::CONFIG["host_os"] =~ /darwin/
        end

        def package_manager
          return :brew if PackageManager.instance.brew?
          return :apt_get if PackageManager.instance.apt_get?
          return :yum if PackageManager.instance.yum?

          raise Ruby::Nginx::PackageManagerError, "Could not determine package manager"
        end

        private

        class PackageManager
          include Singleton

          def initialize
            @semaphore = Mutex.new
          end

          def brew?
            @brew ||= package_with?("brew")
          end

          def yum?
            @yum ||= package_with?("yum")
          end

          def apt_get?
            @apt_get ||= package_with?("apt-get")
          end

          private

          def package_with?(package_manager)
            @semaphore.synchronize do
              TTY::Command.new.run("which #{package_manager}").success?
            end
          end
        end
      end
    end
  end
end
