require './spec/spec_helper'

class AppControllerSpec < StsProxySpec
  describe AppController do
    describe '/check_balance' do
      subject { '/v1/check_balance?Merchant_Number=111111111111&Terminal_ID=220&Action_Code=05&POS_Entry_Mode=M' }

      it 'returns balance' do
        post subject, { number: 711806200498407 }.to_json
        assert last_response.ok?

        assert_instance_of Float, last_response.body['balance'].to_f
      end
    end

    describe '/capture' do
      subject { '/v1/capture?Merchant_Number=111111111111&Terminal_ID=220&Action_Code=01&POS_Entry_Mode=M' }

      it 'returns ok' do
        post subject, { number: 711806200498407, amount: 1, payment_id: 1 }.to_json
        assert last_response.ok?
      end
    end

    describe '/refund' do
      subject { '/v1/refund?Merchant_Number=111111111111&Terminal_ID=220&Action_Code=02&POS_Entry_Mode=M' }

      it 'returns ok' do
        post subject, { number: 711806200498407, amount: 1, payment_id: 1 }.to_json
        assert last_response.ok?
      end
    end
  end
end
