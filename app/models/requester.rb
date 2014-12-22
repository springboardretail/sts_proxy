class Requester
  #todo: make content type a param
  def self.http
    @http ||= begin
      sess = Patron::Session.new
      sess.enable_debug nil
      sess.connect_timeout = 45
      sess.timeout = 45
      sess
    end
  end

  ##
  # Sends a request to the given webhook and returns a
  # hash containing the parsed response body and the raw Patron response
  #
  # @param endpoint [String] address
  # @param body [String] data to be sent
  # @return [Hash] Patron response
  def self.request(endpoint, body)
    http.post endpoint, body, 'Content-Type' => 'application/x-www-form-urlencoded'
  end
end