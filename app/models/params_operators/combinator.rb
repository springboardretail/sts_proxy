##
# Combines json and url params together so that they are ready to be sent to a remote service
class ParamsOperators::Combinator
  attr_accessor :json_params, :url_params

  def initialize(json_params, url_params)
    @json_params = json_params
    @url_params = url_params
  end

  ##
  # Main execution method
  #
  # @return [Hash] combined params
  def run
    json_params.merge(url_params)
  end
end