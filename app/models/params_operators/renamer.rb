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
  # Gets guides for current action
  #
  # @return [Guides]
  def guides
    @guides ||= Guides::GuidesRetriever.get_guides(action)
  end

  ##
  # Renames keys of received params using guides
  #
  # @param guides [Guides]
  # @return [Hash] renamed params
  def rename_keys(guides)
    parsed_result = {}
    data.each do |key, value|
      xml_name = guides.find_input_result(key)
      parsed_result[xml_name] = value
    end
    parsed_result
  end
end
