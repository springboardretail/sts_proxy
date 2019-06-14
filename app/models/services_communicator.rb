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
    data_to_send = change_format(combined_params, :hash, :xml)

    received_data = send_data(data_to_send, sts_url)
    data_to_read = change_format(received_data, :xml, :hash)
    error_hash = errors(data_to_read)

    return error_hash if error_hash.present?
    filter_data(data_to_read, action)
  end

  private

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
    logger.debug('Request to STS:')
    logger.debug(url)
    logger.debug(data)

    content_type = :xml
    response = Requester.request(url, data, content_type)

    logger.debug("Response from STS: Status #{response.status}")
    logger.debug(response.headers.inspect)
    logger.debug(response.body)

    response.body
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
