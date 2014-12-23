##
# Utility class which changes data in one format to another to fit remote service requirements
#
# @note uses active_support
class FormatChanger
  class << self
    ##
    # Transforms hash to xml
    #
    # @param [hash]
    # @return [String] XML
    def from_hash_to_xml(hash)
      hash.to_xml(root: 'Request', skip_types: true, dasherize: false)
    end

    ##
    # Transforms xml to hash
    #
    # @param [String] XML
    # @return [Hash]
    def from_xml_to_hash(xml)
      Hash.from_xml(xml)
    end
  end
end