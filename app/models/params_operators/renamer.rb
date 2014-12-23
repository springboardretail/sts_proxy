##
# Renames received JSON data from SR for remote service requirements using guides for a certain action
class ParamsOperators::Renamer
  attr_accessor :data, :action

  def initialize(data, action)
    @data = data
    @action = action
  end

  ##
  # Main execution method
  #
  # @return [Hash] renamed params
  def run
    rename_keys(guides)
  end

  private

  ##
  # Gets input guides for current action
  #
  # @return [Array of Hash]
  def guides
    @guides ||= Guides::GuidesRetriever.get_guides(action).input
  end

  ##
  # Renames keys of received params using guides
  #
  # @param guides [Array of Hash]
  # @return [Hash] renamed params
  def rename_keys(guides)
    parsed_result = {}
    data.each do |key, value|
      xml_name = guides.find { |hash| hash[:input] == key }[:result]
      parsed_result[xml_name] = value
    end
    parsed_result
  end
end
