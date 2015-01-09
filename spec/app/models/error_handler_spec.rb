require './spec/spec_helper'

class ErrorHandlerSpec < StsProxySpec
  describe ErrorHandler do
    let(:error_response) { { "Response" => { "Response_Code" => "01",
                                             "Response_Text" => "DECLINE 10 CARD BALANCE: $2.04",
                                             "Amount_Balance" => "2.04", "Trans_Date_Time" => "061010140016",
                                             "Transaction_ID" => "206290" } } }
    let(:success_response) { { "Response" => { "Response_Code" => "00", "Response_Text" => "311421",
                                               "Auth_Reference" => "0001", "Amount_Balance" => "0.00",
                                               "Expiration_Date" => "092429", "Trans_Date_Time" => "060710105839",
                                               "Card_Number" => "711194103319309", "Transaction_ID" => "56" } } }
    let(:subject_with_error) { ErrorHandler.new(error_response) }
    let(:subject_without_error) { ErrorHandler.new(success_response) }

    context 'error response' do
      describe '#run' do
        it 'returns an error hash' do
          assert_equal subject_with_error.run, { "message" => "DECLINE 10 CARD BALANCE: $2.04" }
        end
      end

      describe '#failed_response?' do
        it 'returns true' do
          assert_equal subject_with_error.send(:failed_response?), true
        end
      end

      describe '#parse_error' do
        it 'returns a hash with an error message' do
          assert_equal subject_with_error.send(:parse_error), { "message" => "DECLINE 10 CARD BALANCE: $2.04" }
        end
      end
    end

    context 'successful response' do
      describe '#run' do
        it 'returns an empty hash' do
          assert_equal subject_without_error.run, {}
        end
      end

      describe '#failed_response?' do
        it 'returns false' do
          assert_equal subject_without_error.send(:failed_response?), false
        end
      end
    end
  end
end
