require 'sinatra'
require 'sinatra/custom_logger'
require 'yell'
require 'json'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/hash/conversions'
require 'excon'
require 'limiter'

require_relative '../lib/contextual_logger'
##
# Global configurations
class App < Sinatra::Base
  helpers Sinatra::CustomLogger

  set :server, :thin

  configure :production, :development do
    logger = ContextualLogger.new(Yell.new(STDOUT))
    logger.level = ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO

    set :logger, logger
  end

  configure :development do
    require 'better_errors'
    use BetterErrors::Middleware

    logger = ContextualLogger.new(Yell.new(STDOUT))
    logger.level = Logger::DEBUG

    set :logger, logger
  end

  configure :test do
    logger = ContextualLogger.new(Yell.new(STDOUT))
    logger.level = Logger::INFO

    set :logger, logger
  end
end
