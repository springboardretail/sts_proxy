##
# Global configurations
require 'sinatra'
require 'better_errors'

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