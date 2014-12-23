##
#
class ParamsOperators::Renamer
  attr_accessor :data, :action

  def initialize(data, action)
    @data = data
    @action = action
  end

  ##
  #
  def run
    guides = get_guides(action)
    rename_json(guides)
  end

  private

  ##
  #
  def get_guides(action)
    Guides::GuidesRetriever.get_guides(action).input
  end

  ##
  #
  def rename_json(guides)
    parsed_result = {}
    data.each do |key, value|
      xml_name = guides.find { |hash| hash[:input] == key }[:result]
      parsed_result[xml_name] = value
    end
    parsed_result
  end
end