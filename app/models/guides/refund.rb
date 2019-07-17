require './app/models/guides/base'

##
# Contains guides for refund action
class Guides::Refund < Guides::Base
  def input
    [
      {
        input: 'payment_id',
        input_fallback: 'reference_id',
        result: 'Transaction_ID'
      },
      {
        input: 'amount',
        result: 'Transaction_Amount'
      },
      {
        input: 'number',
        result: 'Card_Number'
      }
    ]
  end

  def output
    []
  end
end
