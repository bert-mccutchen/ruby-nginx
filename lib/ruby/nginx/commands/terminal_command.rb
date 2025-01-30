# frozen_string_literal: true

require "tty/command"
require_relative "../system/package_manager"

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
          @result = TTY::Command.new(printer: :null).run!(cmd, user: user)
          raise @error_type, @result.err if error_type && @result.failure?

          @result
        end

        protected

        def darwin?
          RbConfig::CONFIG["host_os"] =~ /darwin/
        end

        def package_manager
          return :brew if Ruby::Nginx::System::PackageManager.instance.brew?
          return :apt_get if Ruby::Nginx::System::PackageManager.instance.apt_get?
          return :yum if Ruby::Nginx::System::PackageManager.instance.yum?

          raise Ruby::Nginx::Error, "Could not determine package manager"
        end
      end
    end
  end
end
