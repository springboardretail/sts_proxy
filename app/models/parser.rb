class Parser
  attr_accessor :body

  def initialize(body)
    @body = body
  end

  def result
    "Hello,12 #{body}"
  end
end