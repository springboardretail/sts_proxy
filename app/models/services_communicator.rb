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

  def initialize(json_params, url_params, action, logger)
    @json_params = json_params
    @url_params = url_params
    @action = action
    @logger = logger
  end

  ##
  # Main execution method
  #
  # @return [Hash] data to be sent to the requester
  def run
    renamed_params = rename_params(json_params, action)
    combined_params = combine_params(renamed_params, url_params)
    received_data = send_data(combined_params, sts_url)
    data_to_read = change_format(received_data, :xml, :hash)
    error_hash = errors(data_to_read)

    return error_hash if error_hash.present?
    filter_data(data_to_read, action)
  end

  private

  DEFAULT_MAX_RETRY_ATTEMPTS = 2
  RETRY_REQUEST_SLEEP_SECONDS = 0.2

  attr_reader :logger, :sts_url

  def sts_url
    @sts_url ||= ENV['STS_GATEWAY_URL'] or raise 'Missing STS gateway URL'
  end

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
  def send_data(data, url)
    response = request(data, url)

    logger.debug("Response from STS: Status #{response.status}")
    logger.debug(response.headers.inspect)

    if response.body.empty?
      logger.debug('EMPTY BODY')
      return unresolved_sts_response
    end

    logger.debug(response.body)
    response.body
  end

  ##
  # Mock an error response format returned by STS
  def unresolved_sts_response
    xml_builder = Builder::XmlMarkup.new(indent: 2)
    xml_builder.tag!('Response') do
      xml_builder.tag!('Response_Code', '01')
      xml_builder.tag!('Response_Text', 'Unresolved action response')
    end
  end

  def should_retry_request?(request_data, response, request_count)
     can_retry_action?(request_data) && response.body.empty? && request_tries_not_exhausted?(request_count)
  end

  def can_retry_action?(data)
    return true if action.to_s == 'check_balance'

    data['Transaction_ID'].present?
  end

  def request_tries_not_exhausted?(request_count)
    request_count <= action_retry_limit
  end

  ##
  # Performs the request on STS API and retry in case action is
  # check_balance and the response body was empty.
  def request(data, url)
    data_to_send = change_format(data, :hash, :xml)
    request_count = 0
    response = do_request(data_to_send, url, request_count)

    until !should_retry_request?(data, response, request_count)
      request_count += 1
      sleep RETRY_REQUEST_SLEEP_SECONDS * request_count
      response = do_request(data_to_send, url, request_count)
    end

    response
  end

  def do_request(data, url, request_count)
    logger.debug("Request to STS (#{request_count + 1}):")
    logger.debug(url)
    logger.debug(data)

    Requester.request(url, data, :xml, retry_limit: action_retry_limit)
  end

  def check_balance?
    action.to_s == 'check_balance'
  end

  def action_retry_limit
    max_attempts = ENV['MAX_RETRY_ATTEMPTS'].to_i
    max_attempts > 0 ? max_attempts : DEFAULT_MAX_RETRY_ATTEMPTS
  end

  def errors(data)
    error_handler = ErrorHandler.new(data)
    error_handler.run
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
