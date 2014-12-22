##
# Parses given json to xml using guides
class JsonToXml
  attr_accessor :data, :guides

  def initialize(data, guides)
    @data = data
    @guides = guides
  end

  def create_xml(json)
    json.to_xml(root: 'Request', skip_types: true, dasherize: false)
  end

  # todo: raise wrong json params here
  def parse_json
    parsed_result = {}
    data.each do |key, value|
      # data.lol
      xml_name = guides.find { |hash| hash[:input] == key }[:result]
      parsed_result[xml_name] = value
    end
    parsed_result
  end
end