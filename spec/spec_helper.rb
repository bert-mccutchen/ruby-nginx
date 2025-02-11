# frozen_string_literal: true

ENV["SKIP_PROMPT"] = "true"

require "ruby/nginx"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |file| require file }

RSpec.configure do |config|
  config.include(RetryHelpers)

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.add_setting :dummy_path
  config.dummy_path = File.expand_path("./dummy", __dir__)

  config.before(:suite) do
    puts "Starting Dummy Server"
    DummyServer.instance.start
  rescue
    DummyServer.instance.stop
  end

  config.after(:suite) do
    puts "Stopping Dummy Server"
    DummyServer.instance.stop
  end
end
