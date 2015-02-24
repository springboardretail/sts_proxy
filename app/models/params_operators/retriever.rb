##
# Gets required data from received response by using output guides for current action
class ParamsOperators::Retriever
  attr_accessor :data, :action

  def initialize(data, action)
    @data = data
    @action = action
  end

  ##
  # Main execution method
  #
  # @return [Hash] result data
  def run
    retrieve_info(guides)
  end

  private

  ##
  # Gets output guides for current action
  #
  # @return [Array of Hash]
  def guides
    @guides ||= Guides::GuidesRetriever.get_guides(action).output
  end

  ##
  # Retrieves needed info from data using guides
  #
  # @param guides [Array of Hash]
  # @return [Hash] needed info
  def retrieve_info(guides)
    result = {}
    guides.each do |guide|
      value = guide[:input].hash_value(data, '/')
      value = guide[:format].call(value) if guide[:format]
      result[guide[:result]] = value
    end
    result
  end
end
