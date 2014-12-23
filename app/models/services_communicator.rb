##
# Main class which transforms given Springboard Retail params into a suitable type for a remote service
# Passes transformed data to the remote service
# Receives response from it
# Transforms and sends the result back to Springboard Retail
#
# @param json_params [Hash] json data from SR
# @param url_params [Hash] url data from SR
# @param action [Symbol] action type
class ServicesCommunicator
  attr_accessor :json_params, :url_params, :action
  STS_URL = 'https://www.smart-transactions.com/testgateway.php'
  #todo: remove these responses for a correct url
  CHECK_BALANCE_RESPONSE = '<Response><Response_Code>00</Response_Code><Response_Text>311421</Response_Text><Auth_Reference>0001</Auth_Reference>
<Amount_Balance>0.00</Amount_Balance><Expiration_Date>092429</Expiration_Date><Trans_Date_Time>060710105839</Trans_Date_Time>
<Card_Number>711194103319309</Card_Number><Transaction_ID>56</Transaction_ID></Response>'
  CAPTURE_RESPONSE = '<Response><Response_Code>00</Response_Code><Response_Text>941215</Response_Text><Auth_Reference>0001</Auth_Reference>
<Amount_Balance>000</Amount_Balance><Expiration_Date>121627</Expiration_Date><Trans_Date_Time>032108122102</Trans_Date_Time>
</Response>'
  REFUND_RESPONSE = '<Response><Response_Code>00</Response_Code><Response_Text>331148</Response_Text><Auth_Reference>0001</Auth_Reference>
<Amount_Balance>16.25</Amount_Balance><Expiration_Date>060130</Expiration_Date><Trans_Date_Time>060710012010</Trans_Date_Time>
<Card_Number>18587500932</Card_Number><Transaction_ID>200862</Transaction_ID></Response>'

  def initialize(json_params, url_params, action)
    @json_params = json_params
    @url_params = url_params
    @action = action
  end

  ##
  # Main execution method
  #
  # @return [Hash] data to be sent to the requester
  def run
    renamed_params = rename_params(json_params, action)
    combined_params = combine_params(renamed_params, url_params)
    data_to_send = change_format(combined_params, :hash, :xml)

    received_data = send_data(data_to_send, STS_URL)
    data_to_read = change_format(received_data, :xml, :hash)
    filter_data(data_to_read, action)
  end

  private

  ##
  # Renames params from SR to STS syntax using guides for a certain action
  #
  # @param json_params [Hash] json data from SR
  # @param action [Symbol] action type
  # @return [Hash] renamed params
  def rename_params(json_params, action)
    params_renamer = ParamsOperators::Renamer.new(json_params, action)
    params_renamer.run
  end

  ##
  # Combines urj params from SR and renamed params to be sent to STS
  #
  # @param url_params [Hash] url data from SR
  # @param renamed_params [Hash] renamed json data from SR
  # @return [Hash] combined params
  def combine_params(renamed_params, url_params)
    params_combinator = ParamsOperators::Combinator.new(renamed_params, url_params)
    params_combinator.run
  end

  ##
  # Changes data format from one to another
  #
  # @param from_format [Symbol]
  # @param to_format [Symbol]
  # @return [?] Data of to_format format
  # @example
  #   change_format(data, :xml, :hash)
  def change_format(data, from_format, to_format)
    FormatChanger.send("from_#{from_format}_to_#{to_format}", data)
  end

  ##
  # Sends data to a remote service
  #
  # @param data [Hash] data to be sent
  # @param url [String] url to send data to
  # @return [String] Response from remote service
  # @todo use real body here
  def send_data(data, url)
    content_type = 'application/x-www-form-urlencoded'
    response = Requester.request(url, data, content_type)
    response.body
    CHECK_BALANCE_RESPONSE
  end

  ##
  # Retrieves data required for certain action from data given
  #
  # @param data [Hash] data to be sent
  # @param action [Symbol] action type
  # @return [Hash] result data
  def filter_data(data, action)
    params_combinator = ParamsOperators::Retriever.new(data, action)
    params_combinator.run
  end
end
