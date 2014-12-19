# app.rb
require 'sinatra'

class StsProxy < Sinatra::Base
  get '/' do
    "Hello, bitch!"
  end
end