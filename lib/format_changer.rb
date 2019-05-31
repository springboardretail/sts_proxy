##
# Utility class which changes data in one format to another to fit remote service requirements
#
# @note uses active_support
class FormatChanger
  class << self
    RATE_LIMIT_MESSAGE = 'STS rate limit reached. The recent Gift Card was not processed yet. Please try again after one minute.'.freeze
    INVALID_BODY_MESSAGE = "Couldn't communicate with STS. Please try again.".freeze
    ##
    # Transforms hash to xml
    #
    # @param [hash]
    # @return [String] XML
    def from_hash_to_xml(hash)
      hash.to_xml(root: 'Request', skip_types: true, dasherize: false, skip_instruct: true)
    end

    ##
    # Transforms xml to hash
    #
    # @param [String] XML
    # @return [Hash]
    def from_xml_to_hash(xml)
      begin
        Hash.from_xml(xml)
      rescue REXML::ParseException => e
        {
          'Response' => {
            'Response_Code' => '01',
            'Response_Text' => error_message_from_invalid_xml(xml)
          }
        }
      end
    end

    ##
    # Returns the error message of an invalid xml
    #
    # @param [String] XML
    # @return [String]
    def error_message_from_invalid_xml(xml)
      xml.include?('INVALID ORIGIN') ? RATE_LIMIT_MESSAGE : INVALID_BODY_MESSAGE
    end
  end
end
