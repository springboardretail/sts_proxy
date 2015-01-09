##
# Handles checking response for errors and displaying them
class ErrorHandler
  # Which key to scan for errors inside
  ERROR_KEY = 'Response/Response_Code'
  # What to look for inside the key
  ERROR_VALUE = '01'

  # Which key to scan for error messages inside
  ERROR_MESSAGE_INPUT_KEY = 'Response/Response_Text'
  # How the value should be handed over to SR
  ERROR_MESSAGE_RESULT_KEY = 'message'

  attr_accessor :data

  def initialize(data)
    @data = data
  end

  ##
  # Main execution method
  #
  # @return [Hash] errors
  def run
    failed_response? ? parse_error : {}
  end

  private

  ##
  # Checks if a response has got any errors
  #
  # @return [Boolean]
  def failed_response?
    ERROR_KEY.hash_value(@data, '/') == ERROR_VALUE
  end

  ##
  # Parses an error using constant guides
  #
  # @return [Hash]
  def parse_error
    result = {}
    result[ERROR_MESSAGE_RESULT_KEY] = ERROR_MESSAGE_INPUT_KEY.hash_value(@data, '/')
    result
  end
end
