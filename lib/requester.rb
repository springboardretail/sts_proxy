##
# Utility class which creates a request
class Requester
  class << self
    def http_connection(endpoint)
      connections = read_variable_from_thread(
        var_name: :connections_by_endpoint,
        initial_value: {}
      )

      connections[endpoint] ||= Excon.new(endpoint)
    end

    def http_rate_limiter
      read_variable_from_thread(
        var_name: :http_rate_limiter,
        initial_value: Limiter::RateQueue.new(
          rate_limit_calls,
          interval: rate_limit_interval
        )
      )
    end

    def read_variable_from_thread(var_name:, initial_value:)
      Thread.current[var_name] ||= initial_value
    end

    def rate_limit_enabled?
      !!ENV['RATE_LIMIT_ENABLED']
    end

    ##
    # Returns the amount of allowed calls to be performed on configured interval.
    # Defaults to 5 in case environment var isn't set
    def rate_limit_calls
      calls = ENV['RATE_LIMIT_CALLS'].to_i
      calls > 0 ? calls : 5
    end

    ##
    # Returns the interval in seconds.
    # Defaults to 1 second in case environment var isn't set
    def rate_limit_interval
      interval = ENV['RATE_LIMIT_INTERVAL'].to_i
      interval > 0 ? interval : 1
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
    def request(endpoint, body, content_type, retry_limit: 0)
      http_rate_limiter.shift if rate_limit_enabled?

      request_options = {
        idempotent: true,
        retry_limit: retry_limit.to_i,
        expects: [200, 201],
        method: :post,
        body: body,
        headers: { 'Content-Type' => content_type }
      }

      http_connection(endpoint).request(request_options)
    end
  end
end
