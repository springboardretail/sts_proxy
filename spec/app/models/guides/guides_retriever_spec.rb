require './spec/spec_helper'

class GuidesRetrieverSpec < StsProxySpec
  describe Guides::GuidesRetriever do
    describe '.get_guides' do
      it 'returns guides for a given action' do
        action = 'check_balance'
        Guides::GuidesRetriever.get_guides(action).must_be_instance_of Guides::CheckBalance
      end
    end
  end
end
