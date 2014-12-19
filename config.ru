require './app/app'
Dir['./app/**/*.rb'].each { |file| require file }

run AppController