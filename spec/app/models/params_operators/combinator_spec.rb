require './spec/spec_helper'

class CombinatorSpec < StsProxySpec
  describe ParamsOperators::Combinator do
    let(:json_params) {{one: 2, two: 3}}
    let(:url_params) {{lol: 2, number: 3}}
    let(:subject) { ParamsOperators::Combinator.new(json_params, url_params) }

    describe '#run' do
      it 'merges two hashes' do
        assert_equal subject.run, { one: 2, two: 3, lol: 2, number: 3 }
      end
    end
  end
end
