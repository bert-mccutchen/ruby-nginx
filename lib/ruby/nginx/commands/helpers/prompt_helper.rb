# frozen_string_literal: true

module Ruby
  module Nginx
    module Commands
      module Helpers
        module PromptHelper
          def yes?(question)
            return true if ENV["SKIP_PROMPT"]

            retry_question = false

            loop do
              response = ask_question(question)

              if !response.nil?
                reset_line if retry_question
                return print_confirm(question, response)
              end

              print_invalid_input && previous_line && reset_line
              retry_question = true
            end
          rescue Interrupt
            next_line && print_confirm(question, false)
            raise Ruby::Nginx::AbortError, "Operation aborted"
          end

          private

          def ask_question(question)
            print "[Ruby::Nginx] #{question} \e[90m(Y/n)\e[0m "

            case $stdin.gets.chomp.downcase
            when "y", "yes"
              true
            when "n", "no"
              false
            end
          end

          def print_confirm(question, allowed)
            previous_line && reset_line

            print "[Ruby::Nginx] #{question} \e[32m#{allowed ? "yes" : "no"}\e[0m\n"
            allowed
          end

          def reset_line
            # 2K = clear line, 1G = move to first column
            print "\e[2K\e[1G"
            true
          end

          def previous_line
            print "\e[1A"
            true
          end

          def next_line
            print "\n"
            true
          end

          def print_invalid_input
            print "\e[31m>>\e[0m Invalid input."
            true
          end
        end
      end
    end
  end
end
