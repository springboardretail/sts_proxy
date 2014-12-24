ENV['RACK_ENV'] = 'test'

require './app/app'
Dir['./lib/**/*.rb'].each { |file| require file }
Dir['./app/**/*.rb'].each { |file| require file }

require 'minitest/autorun'
require 'rack/test'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

include Rack::Test::Methods

def app
  AppController
end
