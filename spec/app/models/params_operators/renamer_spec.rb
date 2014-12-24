require './spec/spec_helper'

class RenamerSpec < StsProxySpec
  describe ParamsOperators::Renamer do
    let subject { ParamsOperators::Renamer.new('', '') }

    describe '#run' do
      it 'renames keys of a hash using guides' do
        #todo implement me
      end
    end

    describe '#guides' do
      it 'returns an input guides hash for a given action' do
        #todo implement me
      end
    end

    describe '#rename_keys' do
      it 'renames hash keys using guides' do
        #todo implement me
      end
    end
  end
end
