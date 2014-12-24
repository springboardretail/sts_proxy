require './spec/spec_helper'

class RetrieverSpec < StsProxySpec
  describe ParamsOperators::Retriever do
    let subject { ParamsOperators::Retriever.new('', '') }

    describe '#run' do
      it 'returns value of a needed key' do
        #todo implement me
      end
    end

    describe '#guides' do
      it 'returns an output guides hash for a given action' do
        #todo implement me
      end
    end

    describe '#retrieve_info' do
      it 'returns value of a needed key' do
        #todo implement me
      end
    end
  end
end
