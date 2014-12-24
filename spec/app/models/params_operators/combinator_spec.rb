require './spec/spec_helper'

class CombinatorSpec < StsProxySpec
  describe ParamsOperators::Combinator do
    let subject { ParamsOperators::Combinator.new('', '') }

    describe '#run' do
      it 'merges two hashes' do
        #todo implement me
      end
    end
  end
end
