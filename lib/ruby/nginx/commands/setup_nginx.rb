# frozen_string_literal: true

require_relative "../constants"
require_relative "../system/safe_file"
require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class SetupNginx < TerminalCommand
        include Ruby::Nginx::Constants

        INCLUDE_STATEMENT = "include #{SERVERS_PATH}/*;"
        EXTERNAL_INCLUDE_STATEMENTS = [
          "include /etc/nginx/sites-enabled/\\*;",
          "include servers/\\*;"
        ]

        def initialize
          super(cmd: "nginx -V", raise: Ruby::Nginx::SetupError)
        end

        def run
          super
          return if setup?

          line = external_include_statement
          config.gsub!(
            "#{line[:indent]}#{line[:statement]}",
            "#{line[:indent]}#{line[:statement]}\n#{line[:indent]}#{INCLUDE_STATEMENT}\n"
          )

          cmd = "echo \"#{config.sub("\"", "\\\"")}\" | sudo tee #{config_file_path}"
          TerminalCommand.new(cmd:, raise: Ruby::Nginx::SetupError).run
        end

        private

        def setup?
          config.include?(INCLUDE_STATEMENT)
        end

        def config_file_path
          # nginx -V outputs to stderr
          @config_file_path ||= result.stderr.split.find { |s| s.include?("--conf-path=") }.delete_prefix("--conf-path=")
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
      end
    end
  end
end
