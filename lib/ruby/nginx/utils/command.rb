# frozen_string_literal: true

module Ruby
  module Nginx
    module Utils
      class Command
        attr_reader :stdout, :stderr, :status

        def initialize(raise: nil)
          @error_type = raise
          @stdout = nil
          @stderr = nil
          @status = nil
        end

        def run(cmd)
          @stdout, @stderr, @status = Open3.capture3(cmd)
          raise @error_type, @stderr if @error_type && !@status.success?

          self
        end

        def self.run(cmd)
          new.run(cmd)
        end
      end
    end
  end
end
