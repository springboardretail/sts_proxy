require './spec/spec_helper'

class RequesterSpec < StsProxySpec
  describe Requester do
    describe '.http' do
      it 'returns a Patron Session' do
        Requester.http.must_be_instance_of Patron::Session
      end
    end

    describe '.request' do
      it 'creates a post request to a url' do
        endpoint = 'http://httpbin.org/post'
        body = {key: 'value'}.to_json
        content_type = 'application/json'

        assert_equal Requester.request(endpoint, body, content_type).status, 200
      end
    end
  end
end
