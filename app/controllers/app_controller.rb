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
  #     {"balance": 0.00}
  def communicate_with_sts(action)
    json_params = JSON.parse(request.body.read)
    combined_params = json_params.merge(params)

    logger.with_context(log_context(combined_params)) do
      services_communicator = ServicesCommunicator.new(json_params, params, action, logger)
      response = services_communicator.run

      if response.empty?
        result = nil
      else
        result = response.to_json
        status(resolve_status(response['message'])) if response['message']
      end

      result
    end
  end

  def resolve_status(result_message)
    result_message.start_with?('INVALID CARD') ? 404 : 500
  end

  def log_context(params)
    context = {
      gift_card_number: params['number'],
      merchant_number: params['Merchant_Number'],
      terminal_id: params['Terminal_ID']
    }

    context.merge!(referer: request.referer) if request.referer

    context
  end
end
