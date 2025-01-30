# frozen_string_literal: true

require "singleton"
require "tty/command"

module Ruby
  module Nginx
    module System
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
            TTY::Command.new(printer: :null).run!("which #{package_manager}").success?
          end
        end
      end
    end
  end
end
