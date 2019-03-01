require 'sinatra'
require 'json'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/hash/conversions'
require 'rest_client'

##
# Global configurations
class App < Sinatra::Base
  set :server, :thin

  configure :production, :development do
    set :logging, ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO
  end

  configure :development do
    require 'better_errors'
    set :logging, Logger::DEBUG
    use BetterErrors::Middleware
  end
end
