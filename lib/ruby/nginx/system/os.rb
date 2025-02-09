# frozen_string_literal: true

require "singleton"
require "tty/command"

module Ruby
  module Nginx
    module System
      class OS
        include Singleton

        def initialize
          @semaphore = Mutex.new
        end

        def darwin?
          RbConfig::CONFIG["host_os"] =~ /darwin/
        end

        def package_manager
          @package_manager ||=
            if darwin?
              :brew if package_with?("brew")
            elsif package_with?("apt-get")
              :apt_get
            elsif package_with?("pacman")
              :pacman
            elsif package_with?("yum")
              :yum
            elsif package_with?("zypper")
              :zypper
            end

          return @package_manager if @package_manager
          raise Ruby::Nginx::Error, "Could not determine package manager"
        end

        private

        def package_with?(package_manager)
          @semaphore.synchronize do
            TTY::Command.new(printer: :null).run!("which #{package_manager}").success?
          end
        end
      end
    end
  end
end
