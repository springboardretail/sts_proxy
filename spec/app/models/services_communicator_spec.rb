require './spec/spec_helper'

class ServicesCommunicatorSpec < StsProxySpec
  describe ServicesCommunicator do
    let(:card_number) { 711806200498407 }
    let(:merchant_number) { 111111111111 }
    let(:terminal_id) { 220 }

    let(:json_params) { { 'number' => card_number} }
    let(:url_params) { {'Merchant_Number' => 111111111111, 'Terminal_ID' => 220, 'Action_Code' => 05} }
    let(:action) { :check_balance }
    # let(:sts_url) { 'https://www.smart-transactions.com/gateway_no_lrc.php' }
    let(:sts_url) { 'http://httpbin.org/post' }

    let(:subject) { ServicesCommunicator.new(json_params, url_params, action) }

    let(:renamed_params) { subject.send(:rename_params, json_params, action) }
    let(:combined_params) { subject.send(:combine_params, renamed_params, url_params) }
    let(:formatted_to_xml) { subject.send(:change_format, combined_params, :hash, :xml) }
    let(:received_data) { subject.send(:send_data, formatted_to_xml, sts_url) }
    let(:formatted_to_hash) { subject.send(:change_format, received_data, :xml, :hash) }
    let(:filtered_data) { subject.send(:filter_data, formatted_to_hash, action) }

    describe '#run' do
      it 'returns a data hash from a remote server' do
        assert_equal subject.run, { "balance" => "0.00" }
      end
    end

    describe '#rename_params' do
      it 'returns renamed hash params for a certain action' do
        assert_equal renamed_params, { 'Card_Number' => card_number }
      end
    end

    describe '#combine_params' do
      it 'returns two combined hashes' do
        assert_equal combined_params,
                     { 'Card_Number' => card_number, 'Merchant_Number' => merchant_number, 'Terminal_ID' => terminal_id, 'Action_Code' => 05 }
      end
    end

    describe '#change_format' do
      let(:expected_xml) do
        xml_builder = Builder::XmlMarkup.new(indent: 2)
        xml_builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'
        xml_builder.tag!('Request') {
          xml_builder.tag! 'Card_Number', card_number
          xml_builder.tag! 'Merchant_Number', merchant_number
          xml_builder.tag! 'Terminal_ID', terminal_id
          xml_builder.tag! 'Action_Code', 05
        }
      end

      let(:expected_hash) { { "Response" => { "Response_Code" => "00", "Response_Text" => "311421",
                                              "Auth_Reference" => "0001", "Amount_Balance" => "0.00",
                                              "Expiration_Date" => "092429", "Trans_Date_Time" => "060710105839",
                                              "Card_Number" => card_number.to_s, "Transaction_ID" => "56" } } }

      it 'converts hash to xml' do
        assert_equal formatted_to_xml, expected_xml
      end

      it 'converts xml to hash' do
        assert_equal formatted_to_hash, expected_hash
      end
    end

    describe '#send_data' do
      it 'returns data from a remote url' do
        skip 'must receive real response'
        assert_equal received_data, 'real response'
      end
    end

    describe '#errors' do
      context 'error response' do
        error_response = { "Response" => { "Response_Code" => "01",
                                           "Response_Text" => "DECLINE 10 CARD BALANCE: $2.04",
                                           "Amount_Balance" => "2.04", "Trans_Date_Time" => "061010140016",
                                           "Transaction_ID" => "206290" }
        }

        it 'returns a hash with an error message' do
          assert_equal subject.send(:errors, error_response), { "message" => "DECLINE 10 CARD BALANCE: $2.04" }
        end
      end

      context 'successful response' do
        it 'returns an empty hash' do
          assert_equal subject.send(:errors, formatted_to_hash), {}
        end
      end
    end

    describe '#filter_data' do
      it 'returns only a required data for a certain action' do
        assert_equal filtered_data, { "balance" => "0.00" }
      end
    end
  end
end
