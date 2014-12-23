##
#
class ParamsOperators::Retriever
  attr_accessor :data, :action

  def initialize(data, action)
    @data = data
    @action = action
  end

  ##
  #
  def run
    guides = get_guides(action)
    retrieve_info(guides)
  end

  private

  ##
  #
  def get_guides(action)
    Guides::GuidesRetriever.get_guides(action).output
  end

  ##
  #
  def retrieve_info(guides)
    result = {}
    guides.each do |guide|
      value = guide[:input].hash_value(data, '/')
      result[guide[:result]] = value
    end
    result
  end
end
