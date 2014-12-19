class AppController < App
  get '/:data' do
    parser = Parser.new(params[:data])
    parser.result
  end

  post '/' do
    json_params = JSON.parse(request.body.read)
    { balance: json_params['balance'] + 50 }.to_json
  end
end