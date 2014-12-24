require './spec/spec_helper'

class FormatChangerSpec < StsProxySpec
  describe FormatChanger do
    let(:xml) do
      xml_builder = Builder::XmlMarkup.new(indent: 2)
      xml_builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      xml_builder.tag!('Request') {
        xml_builder.key 'value'
        xml_builder.key2 1234
      }
    end

    describe '.from_hash_to_xml' do
      let(:some_hash) { { key: 'value', key2: 1234 } }

      it 'transforms hash to xml' do
        expected_xml = FormatChanger.from_hash_to_xml(some_hash)

        assert_equal(xml, expected_xml)
      end
    end

    describe '.from_xml_to_hash' do
      let(:some_hash) { { 'Request' => { 'key' => 'value', 'key2' => '1234' } } }

      it 'transforms xml to hash' do
        expected_hash = FormatChanger.from_xml_to_hash(xml)

        assert_equal(some_hash, expected_hash)
      end
    end
  end
end
