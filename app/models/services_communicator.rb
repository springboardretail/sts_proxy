##
# Mega class which transforms given Springboard Retail params into a suitable type for a remote service
# Handles result to the remote service
# Receives response from it
# Transforms and sends the result to Springboard Retail
#
# @param json_params [Hash] json data from SR
# @param url_params [Hash] url data from SR
# @param action [Symbol] action type
class ServicesCommunicator
  attr_accessor :json_params, :url_params, :action

  def initialize(json_params, url_params, action)
    @json_params = json_params
    @url_params = url_params
    @action = action
  end

  def run
    renamed_params = rename_params(json_params, action)
    combined_params = combine_params(renamed_params, url_params)
    data_to_send = change_format(combined_params, :hash, :xml)

    received_data = send_data(data_to_send, 'https://www.smart-transactions.com/testgateway.php')
    data_to_read = change_format(received_data, :xml, :hash)
    get_result(data_to_read, action)
  end

  private

  ##
  #
  def rename_params(json_params, action)
    params_renamer = ParamsOperators::Renamer.new(json_params, action)
    params_renamer.run
  end

  ##
  #
  def combine_params(renamed_params, url_params)
    params_combinator = ParamsOperators::Combinator.new(renamed_params, url_params)
    params_combinator.run
  end

  ##
  #
  def change_format(params, from_format, to_format)
    # params.lol
    # from_format.lol
    # to_format.lol
    FormatChanger.send("from_#{from_format}_to_#{to_format}", params)
  end

  ##
  #
  #
  #
  # @todo: get right response body
  def send_data(data, url)
    content_type = 'application/x-www-form-urlencoded'
    response = Requester.request(url, data, content_type)
    response.body
    '<Response><Response_Code>00</Response_Code><Response_Text>311421</Response_Text><Auth_Reference>0001</Auth_Reference>
<Amount_Balance>0.00</Amount_Balance><Expiration_Date>092429</Expiration_Date><Trans_Date_Time>060710105839</Trans_Date_Time>
<Card_Number>711194103319309</Card_Number><Transaction_ID>56</Transaction_ID></Response>'
  end

  ##
  #
  def get_result(data, action)
    params_combinator = ParamsOperators::Retriever.new(data, action)
    params_combinator.run
  end
end