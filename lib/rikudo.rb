require 'sinatra/json'
require 'models/event'

class Rikudo < Sinatra::Base
  set :root, File.expand_path('..', __dir__)
  SORTABLE_COLUMNS = %w[status name host retries].freeze
  get '/' do
    authorized_params = {}
    authorized_params[:muted] = false if params['muted'] == '0'
    authorized_params[:reverse] = true if params['reverse'] == '1'
    authorized_params[:threshold] = true if params['threshold'] == '1'
    if params[:sorted]
      authorized_params[:sorted] = params[:sorted].to_sym if SORTABLE_COLUMNS.include? params[:sorted]
    end
    @events = Event.for_display(**authorized_params)
    slim :index
  end
end