require "singleton"

class DummyServer
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @pid = nil
  end

  def start
    @semaphore.synchronize do
      @pid = Process.fork do
        require "puma"
        require "puma/cli"

        dummy_path = File.expand_path("../dummy", __dir__)

        Puma::CLI.new(["-s", "--dir=#{dummy_path}"]).run
      end
    end
  end

  def stop
    @semaphore.synchronize do
      Process.kill(:TERM, @pid)
      Process.wait
    end
  end
end
