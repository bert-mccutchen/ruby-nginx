# frozen_string_literal: true

module Ruby
  module Nginx
    module Exceptions
      Error = Class.new(StandardError)
      InstallError = Class.new(Error)
      SetupError = Class.new(Error)
      CreateError = Class.new(Error)
      ConfigError = Class.new(Error)
      StartError = Class.new(Error)
      StopError = Class.new(Error)
    end
  end
end
