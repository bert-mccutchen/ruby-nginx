# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class NginxOptions < TerminalCommand
        def initialize
          super(cmd: "nginx -V", raise: Ruby::Nginx::Error)
        end

        def run
          super

          # nginx -V outputs to stderr
          format_output(result.stderr)
        end

        private

        def format_output(output)
          output.split(/configure arguments: */)[1].split.map(&method(:format_option)).to_h
        end

        def format_option(option)
          key_val = option.split("=")
          [key_val[0], key_val[1] || true]
        end
      end
    end
  end
end
