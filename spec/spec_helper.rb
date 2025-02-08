# frozen_string_literal: true

require "puma"
require "puma/cli"
require "ruby/nginx"

ENV["SKIP_PROMPT"] = "true"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.add_setting :dummy_dir
  config.dummy_dir = File.expand_path("./dummy", __dir__)

  config.before(:suite) do
    print "Starting Dummy Server"
    $dummy_server = Thread.new do # standard:disable Style/GlobalVars
      Puma::CLI.new(["-s", "--dir=#{RSpec.configuration.dummy_dir}"]).run
    end
  end

  config.after(:suite) do
    print "Stopping Dummy Server"
    $dummy_server.exit if $dummy_server.alive? # standard:disable Style/GlobalVars
  end
end
