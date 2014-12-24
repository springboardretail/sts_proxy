require './app/app'
require './app/models/params_operators'
require './app/models/guides'
Dir['./lib/**/*.rb'].each { |file| require file }
Dir['./app/**/*.rb'].each { |file| require file }

run AppController