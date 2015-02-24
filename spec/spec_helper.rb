ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'minitest/reporters'
require 'builder'
require 'maxitest/autorun'
require 'vcr'
include Rack::Test::Methods

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

require './app/app'
require './app/models/params_operators'
require './app/models/guides'
Dir['./lib/**/*.rb'].each { |file| require file }
Dir['./app/**/*.rb'].each { |file| require file }

def app
  AppController
end

class StsProxySpec < MiniTest::Spec
  around do |test|
    VCR.use_cassette('default', record: :new_episodes) do
      test.call
    end
  end
end
