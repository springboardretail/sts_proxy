require './spec/spec_helper'

class StringSpec < StsProxySpec
  describe String do
    describe '#hash_value' do
      it 'returns a hash value using a string as a map' do
        some_hash = { 'Response' => { 'Amount_Balance' => 5 } }
        string_map = 'Response/Amount_Balance'

        expected_result = 5

        assert_equal(string_map.hash_value(some_hash, '/'), expected_result)
      end

      it 'returns a hash value using a string as a map' do
        some_hash = { 'Request' => { 'key' => 'value', 'key2' => '1234' } }
        string_map = 'Request:key2'

        expected_result = '1234'

        assert_equal(string_map.hash_value(some_hash, ':'), expected_result)
      end
    end
  end
end
