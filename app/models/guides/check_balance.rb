require './app/models/guides/base'

##
# Contains guides for check balance action
class Guides::CheckBalance < Guides::Base
  def input
    [
      {
        input: 'number',
        result: 'Card_Number'
      }
    ]
  end

  def output
    [
      {
        input: 'Response/Amount_Balance',
        result: 'balance'
      }
    ]
  end
end