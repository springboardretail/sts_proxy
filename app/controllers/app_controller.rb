##
# Main controller
class AppController < App
  get '/' do
    "<h1>Hi. Please refer to <a href='https://github.com/cbrwizard/sts_proxy'>code repo</a> in order to learn how to use this app.</h1>"
  end

  ##
  # Checks balance of a gift card using STS
  post '/v1/check_balance' do
    communicate_with_sts(:check_balance)
  end

  ##
  # Captures an amount of a gift card using STS
  post '/v1/capture' do
    communicate_with_sts(:capture)
  end

  ##
  # Refunds an amount of a gift card using STS
  #
  # @note also serves as a void action
  post '/v1/refund' do
    communicate_with_sts(:refund)
  end

  private

  ##
  # Main action which calls a service communicator to receive data from STS
  #
  # @param action [Symbol] gift card action
  # @return [JSON or nil]
  # @example
  #   /v1/check_balance?Merchant_Number=111111111111&Terminal_ID=111&Action_Code=05&Trans_Type=N&POS_Entry_Mode=M
  #   with raw
  #   {
  #     "number" : 11111
  #   }
  #   results in
  #     {"balance":"0.00"}
  def communicate_with_sts(action)
    json_params = JSON.parse(request.body.read)
    services_communicator = ServicesCommunicator.new(json_params, params, action)
    response = services_communicator.run
    response.empty? ? nil : response.to_json
  end
end
