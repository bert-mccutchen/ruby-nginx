require "puma"
require "puma/cli"
require "singleton"

ENV["SKIP_PROMPT"] = "true"
DUMMY_PATH = File.expand_path("../dummy", __dir__)

class DummyServer
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @server = nil
  end

  def start
    @semaphore.synchronize do
      @server = Thread.new do # standard:disable Style/GlobalVars
        Puma::CLI.new(["-s", "--dir=#{DUMMY_PATH}"]).run
      end
    end
  end

  def stop
    @semaphore.synchronize do
      @server.exit if @server.alive?
    end
  end
end
