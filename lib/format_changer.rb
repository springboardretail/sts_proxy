##
#
class FormatChanger
  class << self
    ##
    #
    def from_hash_to_xml(hash)
      hash.to_xml(root: 'Request', skip_types: true, dasherize: false)
    end

    ##
    #
    def from_xml_to_hash(xml)
      Hash.from_xml(xml)
    end
  end
end