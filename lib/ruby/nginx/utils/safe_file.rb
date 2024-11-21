# frozen_string_literal: true

require "fileutils"

module Ruby
  module Nginx
    module Utils
      class SafeFile
        class << self
          def touch(file_path)
            safe_path = File.expand_path(file_path)

            FileUtils.mkdir_p(File.dirname(safe_path))
            FileUtils.touch(safe_path)

            safe_path
          end

          def write(file_path, content)
            safe_path = touch(file_path)

            File.write(safe_path, content)

            safe_path
          end

          private

          def safe_path(file_path)
            File.expand_path(file_path)
          end
        end
      end
    end
  end
end
