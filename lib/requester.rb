##
# Utility class which creates a request
class Requester
  class << self
    ##
    # Sends a POST request to the given address and returns a
    # hash containing the parsed response body and the raw Patron response
    #
    # @note may use a proxy to make sure that website is accessible everywhere
    # @param endpoint [String] address
    # @param body [String] data to be sent
    # @param content_type [String]
    # @return [Hash] Patron response
    def request(endpoint, body, content_type)
      Excon.post(endpoint, {
        body: body,
        headers: { 'Content-Type' => content_type }
      })
    end
  end
end
