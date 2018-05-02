require 'sinatra/json'
require 'models/event'
require 'better_errors'

class Rikudo < Sinatra::Base
  set :root, File.expand_path('..', __dir__)
  SORTABLE_COLUMNS = %w[status name host retries].freeze

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = root
  end

  # TODO: Have a controller
  get '/' do
    display_params = {
      filters: (params['filters'] || '').split(',').map(&:to_sym),
    }

    if params[:order]
      column, dir = params[:order].split(':')
      dir = :asc unless dir == 'desc'

      display_params.merge! order_by: column.to_sym, order_dir: dir.to_sym
    end

    @events = Event.for_display(**display_params)
    slim :index
  end
end
