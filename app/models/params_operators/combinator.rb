##
#
class ParamsOperators::Combinator
  attr_accessor :json_params, :url_params

  def initialize(json_params, url_params)
    @json_params = json_params
    @url_params = url_params
  end

  def run
    json_params.merge(url_params)
  end
end