require 'sinatra/base'
require 'pry'
require 'sinatra/json'

require './models/result'

class Rikudo < Sinatra::Base
  get '/' do
    @results = Result.all.sort_by(&:status).reverse
    slim :index
  end
end

run Rikudo
