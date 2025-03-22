# frozen_string_literal: true

require "fileutils"

module Ruby
  module Nginx
    module System
      class SafeFile
        class << self
          def mkdir(dir_path)
            safe_path = File.expand_path(dir_path)

            FileUtils.mkdir_p(dir_path)

            safe_path
          end

          def touch(file_path)
            safe_path = File.expand_path(file_path)

            FileUtils.mkdir_p(File.dirname(safe_path))
            FileUtils.touch(safe_path)

            safe_path
          end

          def read(file_path)
            safe_path = File.expand_path(file_path)

            File.read(safe_path)
          end

          def write(file_path, content)
            safe_path = touch(file_path)

            File.write(safe_path, content)

            safe_path
          end

          def rm(file_path)
            safe_path = File.expand_path(file_path)

            FileUtils.rm_f(safe_path)
          end
        end
      end
    end
  end
end
