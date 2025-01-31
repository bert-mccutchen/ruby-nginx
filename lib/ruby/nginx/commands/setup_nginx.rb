# frozen_string_literal: true

require_relative "../constants"
require_relative "../system/nginx"
require_relative "../system/safe_file"
require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class SetupNginx < TerminalCommand
        include Ruby::Nginx::Constants

        INCLUDE_STATEMENT = "include #{File.expand_path(SERVERS_PATH)}/*;"
        EXTERNAL_INCLUDE_STATEMENTS = [
          "include /etc/nginx/sites-enabled/\\*;",
          "include servers/\\*;"
        ]

        def initialize(sudo: false)
          @sudo = sudo
          cmd = "echo \"#{new_config}\" | #{sudoify("tee #{config_file_path}", sudo)}"

          super(cmd:, raise: Ruby::Nginx::SetupError)
        end

        def run
          super unless setup?
        rescue Ruby::Nginx::SetupError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(sudo: true).run
        end

        private

        def setup?
          config.include?(INCLUDE_STATEMENT)
        end

        def config_file_path
          @config_file_path ||= Ruby::Nginx::System::Nginx.options["--conf-path"]
        end

        def config
          @config ||= Ruby::Nginx::System::SafeFile.read(config_file_path)
        end

        def external_include_statement
          EXTERNAL_INCLUDE_STATEMENTS.each do |statement|
            match = config.match(/(?<indent>\s*)(?<statement>#{statement})/)
            return match if match
          end

          raise Ruby::Nginx::SetupError,
            "Could not find a suitable place to add the include statement.\n" \
            "Please add the following line to your nginx configuration file:\n" \
            "#{INCLUDE_STATEMENT}"
        end

        def new_config
          match = external_include_statement
          indent = match[:indent]
          statement = match.to_s

          config
            .gsub(statement, "#{statement}\n#{indent}#{INCLUDE_STATEMENT}\n")
            .gsub("\"", "\\\"")
        end
      end
    end
  end
end
