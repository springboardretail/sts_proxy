class AppController < App
  ## Также считывать остальные параметры из JSON url (Merchant_Number, Terminal_ID)
  ## И задаем в коде параметры Action_Code = 05, Business Type = R, Trans_Type = N, POS_Entry_mode = M
  ## Парсим, создаем XML, отправляем результат на записанный тут адрес и получаем XML.
  ## Парсим XML, создаем JSON с balance: N из Amount_Balance, туда же записываем Auth_Reference
  post '/v1/check_balance' do
    communicate_with_sts(:check_balance)
  end

  ##
  # Main action which calls a service communicator to receive data from a remote service
  #
  # @param action [Symbol] card action
  # @return [JSON]
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
    response.to_json
  end
end
