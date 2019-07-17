require './spec/spec_helper'

class GuidesCaptureSpec < StsProxySpec
  describe Guides::Base do

    class ExampleGuide < Guides::Base
      def input
        [
          {
            input: 'foo',
            result: 'Foo'
          },
          {
            input: 'bar',
            input_fallback: 'baz',
            result: 'Bar',
          }
        ]
      end
    end

    let(:subject) { ExampleGuide.new }

    describe '#find_input_result' do
      it 'returns the input result value matching the given key' do
        assert_equal(subject.find_input_result('foo'), 'Foo')
      end

      context 'when input does not match' do
        it 'returns input result value matching on input fallback' do
          assert_equal(subject.find_input_result('baz'), 'Bar')
        end
      end
    end

    describe '#find_input' do
      it 'returns the input matching the given key against input' do
        assert_equal(subject.find_input('foo'), {
          input: 'foo',
          result: 'Foo'
        })
      end

      it 'returns the input matching the given key against input fallback' do
        assert_equal(subject.find_input('baz'), {
          input: 'bar',
          input_fallback: 'baz',
          result: 'Bar'
        })
      end
    end
  end
end
