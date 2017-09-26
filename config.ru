require 'sinatra/base'
require 'pry'
require 'sinatra/json'

require './models/result'

class Rikudo < Sinatra::Base
  get '/' do
    Result.all
  end
end

run Rikudo
