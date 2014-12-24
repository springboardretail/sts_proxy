require './spec/spec_helper'

class RetrieverSpec < StsProxySpec
  describe ParamsOperators::Retriever do
    let(:data) { {'Response' => { 'Amount_Balance' => 5, 'key2' => '1234' }} }
    let(:action) { 'check_balance' }
    let(:subject) { ParamsOperators::Retriever.new(data, action) }

    describe '#run' do
      it 'returns a needed key/value pair' do
        assert_equal subject.run, {'balance' => 5}
      end
    end

    describe '#guides' do
      it 'returns an output guides hash for a given action' do
        subject.send(:guides).must_be_instance_of Array
      end
    end

    describe '#retrieve_info' do
      it 'returns value of a needed key' do
        assert_equal subject.send(:retrieve_info, subject.send(:guides)), { 'balance' => 5 }
      end
    end
  end
end
