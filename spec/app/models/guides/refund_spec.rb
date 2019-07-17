require './spec/spec_helper'

class GuidesCaptureSpec < StsProxySpec
  describe Guides::Refund do
    let(:subject) { Guides::Refund.new }

    describe '#input' do
      it 'returns the valid parameters and their STS representation' do
        expected_input = [
          {
            input: 'payment_id',
            result: 'Transaction_ID',
            input_fallback: 'reference_id'
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

        assert_equal(subject.input, expected_input)
      end
    end

    describe '#output' do
      it 'returns empty list' do
        assert_equal(subject.output, [])
      end
    end
  end
end
