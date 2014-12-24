require './spec/spec_helper'

class AppControllerSpec < StsProxySpec
  describe AppController do
    describe '/check_balance' do
      subject { '/v1/check_balance?Merchant_Number=999&Terminal_ID=999&Action_Code=05&Trans_Type=N&POS_Entry_Mode=M' }

      it 'returns balance' do
        post subject, { number: 'abcde' }.to_json
        assert last_response.ok?
        assert_equal({ balance: '0.00' }.to_json, last_response.body)
      end
    end

    describe '/capture' do
      subject { '/v1/capture?Merchant_Number=999&Terminal_ID=999&Action_Code=01&Trans_Type=N&POS_Entry_Mode=M&Business_Type=R' }

      it 'returns ok' do
        post subject, { number: 'abcde', amount: 1, payment_id: 1 }.to_json
        assert last_response.ok?
      end
    end

    describe '/refund' do
      subject { '/v1/refund?Merchant_Number=999&Terminal_ID=999&Action_Code=01&Trans_Type=N&POS_Entry_Mode=M&Business_Type=R' }

      it 'returns ok' do
        post subject, { number: 'abcde', amount: 1, payment_id: 1 }.to_json
        assert last_response.ok?
      end
    end
  end
end
