# frozen_string_literal: true

require "open3"
require_relative "command"
require_relative "safe_file"

module Ruby
  module Nginx
    module Utils
      class Nginx
        class Error < StandardError; end

        class InstallError < Error; end

        class ConfigError < Error; end

        class StartError < Error; end

        class StopError < Error; end

        class << self
          def add_server_config(name, config)
            SafeFile.write(server_config_path(name), config)
          end

          def remove_server_config(name)
            FileUtils.rm_f(server_config_path(name))
          end

          def validate_config!
            Command.new(raise: ConfigError).run("nginx -t")
          end

          def start!
            Command.new(raise: StartError).run("nginx")
          end

          def stop!
            Command.new(raise: StopError).run("nginx -s stop")
          rescue StopError => e
            raise unless e.message.include?("invalid PID number")
          end

          def restart!
            stop!
            start!
          end

          private

          def config_file_path
            result = Command.new(raise: Error).run("nginx -V")
            result.stderr.split.find { |s| s.include?("--conf-path=") }.delete_prefix("--conf-path=")
          end

          def server_config_path(name)
            "#{File.dirname(config_file_path)}/servers/#{name}.conf"
          end
        end
      end
    end
  end
end
