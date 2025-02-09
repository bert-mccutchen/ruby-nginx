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
