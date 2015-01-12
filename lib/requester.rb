##
# Utility class which creates a request
class Requester
  class << self
    ##
    # Sends a POST request to the given address and returns a
    # hash containing the parsed response body and the raw Patron response
    #
    # @param endpoint [String] address
    # @param body [String] data to be sent
    # @param content_type [String]
    # @return [Hash] Patron response
    def request(endpoint, body, content_type)
      RestClient.post endpoint, body, content_type: content_type
    end
  end
end
