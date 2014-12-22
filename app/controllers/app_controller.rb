class AppController < App
  get '/:data' do
    # parser = JsonToXml.new(params[:data])
    # parser.result
  end

  post '/' do
    ## Todo: сделать тут check_balance, который считывает JSON request body c number и конвертировать его в card number.
    ## Также считывать остальные параметры из JSON url (Merchant_Number, Terminal_ID)
    ## И задаем в коде параметры Action_Code = 05, Business Type = R, Trans_Type = N, POS_Entry_mode = M
    ## Парсим, создаем XML, отправляем результат на записанный тут адрес и получаем XML.
    ## Парсим XML, создаем JSON с balance: N из Amount_Balance, туда же записываем Auth_Reference
    json_params = JSON.parse(request.body.read)
    { balance: json_params['balance'] + 50 }.to_json
  end

  # todo: call a class here and do nothing in a controller
  post '/check_balance' do
    json_params = JSON.parse(request.body.read)
    # todo: use url param as class name
    # params.lol
    # todo: rescue wrong json params here
    # rename as JsonRequestToXML
    json_to_xml = JsonToXml.new(json_params, Guides::CheckBalance.new('check_balance').guides)
    renamed_json = json_to_xml.parse_json
    json = renamed_json.merge(params)
    xml_to_send = json_to_xml.create_xml(json)
    # xml_to_send.lol
    response = Requester.request('https://www.smart-transactions.com/testgateway.php', xml_to_send)
    response_xml = response.body

    # UrlRequestToXML

    response_xml = '<Response><Response_Code>00</Response_Code><Response_Text>311421</Response_Text><Auth_Reference>0001</Auth_Reference>
<Amount_Balance>0.00</Amount_Balance><Expiration_Date>092429</Expiration_Date><Trans_Date_Time>060710105839</Trans_Date_Time>
<Card_Number>711194103319309</Card_Number><Transaction_ID>56</Transaction_ID></Response>'
    response_xml.to_json
    response_hash = Hash.from_xml(response_xml)['Response']
    if response_hash['Response_Code'] == '00'
      {balance: response_hash['Amount_Balance']}.to_json
    else
      # escape error
    end

  end
end
