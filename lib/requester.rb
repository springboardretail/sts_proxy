##
# Utility class which creates a request
class Requester
  class << self
    def http_connection(endpoint)
      if !Thread.current.thread_variable?(:connections_by_endpoint)
        Thread.current.thread_variable_set(:connections_by_endpoint, {})
      end

      connections = Thread.current.thread_variable_get(:connections_by_endpoint)
      connections[endpoint] ||= Excon.new(endpoint, persistent: true)
    end

    ##
    # Sends a POST request to the given address and returns a
    # hash containing the parsed response body and the raw Patron response
    #
    # @note may use a proxy to make sure that website is accessible everywhere
    # @param endpoint [String] address
    # @param body [String] data to be sent
    # @param content_type [String]
    # @return [Hash] Excon response
    def request(endpoint, body, content_type)
      http_connection(endpoint).post(
        body: body,
        headers: { 'Content-Type' => content_type }
      )
    end
  end
end
