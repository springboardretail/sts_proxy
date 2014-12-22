##
# Global configurations
require 'sinatra'
require 'better_errors'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/hash/conversions'
require 'patron'

class App < Sinatra::Base
  set :server, :thin
  enable :sessions

  configure :production, :development do
    enable :logging
  end

  configure :development do
    use BetterErrors::Middleware
  end
end