require './spec/spec_helper'

class RenamerSpec < StsProxySpec
  describe ParamsOperators::Renamer do
    let(:data) {{'number' => 2}}
    let(:action) {:check_balance}
    let(:subject) { ParamsOperators::Renamer.new(data, action) }

    describe '#run' do
      it 'renames keys of a hash using guides' do
        assert_equal subject.run, {'Card_Number' => 2}
      end
    end

    describe '#guides' do
      it 'returns an input guides array for a given action' do
        subject.send(:guides).must_be_instance_of Array
      end
    end

    describe '#rename_keys' do
      it 'renames hash keys using guides' do
        assert_equal subject.send(:rename_keys, subject.send(:guides)), { 'Card_Number' => 2 }
      end
    end
  end
end
