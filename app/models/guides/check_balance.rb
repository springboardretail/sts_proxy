require './app/models/guides/base'

class Guides::CheckBalance < Guides::Base
  def guides
    [
      {
        input: 'number',
        result: 'Card_Number'
      }
    ]
  end
end