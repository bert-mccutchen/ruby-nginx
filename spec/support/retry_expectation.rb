module RetryHelpers
  class RetryExpectation
    def initialize(limit:, delay:)
      @limit = limit
      @delay = delay
      @count = 0
    end

    def attempt
      yield
    rescue RSpec::Expectations::ExpectationNotMetError
      raise if @count >= @limit
      sleep(@delay) if @delay
      @count += 1
      retry
    end
  end

  def retry_expectation(limit: 3, delay: 0.1, &block)
    RetryExpectation.new(limit: limit, delay: delay).attempt(&block)
  end
end
