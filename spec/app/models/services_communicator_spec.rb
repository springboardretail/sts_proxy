require './spec/spec_helper'

class ServicesCommunicatorSpec < StsProxySpec
  describe ServicesCommunicator do
    let subject { ServicesCommunicator.new('', '', '') }

    describe '#run' do
      it 'returns a data hash from a remote server' do
        #todo implement me
      end
    end

    describe '#rename_params' do
      it 'returns renamed hash params for a certain action' do
        #todo implement me
      end
    end

    describe '#combine_params' do
      it 'returns two combined hashes' do
        #todo implement me
      end
    end

    describe '#change_format' do
      it 'converts hash to xml' do
        #todo implement me
      end

      it 'converts xml to hash' do
        #todo implement me
      end
    end

    describe '#send_data' do
      it 'returns data from a remote url' do
        #todo implement me
      end
    end

    describe '#filter_data' do
      it 'returns only a required data for a certain action' do
        #todo implement me
      end
    end
  end
end
