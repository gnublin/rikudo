require 'faraday'
require 'faraday_middleware'

class Event
  STATUS_NAMES = %w[OK Warning Critical Unknown]

  attr_reader :status, :muted, :host, :retries, :last_ok, :last_failure, :name, :threshold

  def initialize(sensu_events)
    @status = sensu_events['check']['status']
    @muted = sensu_events['silenced']
    @host = sensu_events['client']['name']
    @retries = sensu_events['occurrences']
    @last_ok = Time.at(sensu_events['last_ok'])
    @last_failure = Time.at(sensu_events['check']['issued'])
    @threshold = sensu_events['check']['occurrences']
    @name = sensu_events['check']['name']
  end

  class << self
    def all
      fetch_events.map! do |t|
        Event.new(t)
      end
    end

    FILTERS = {
      muted: -> row { row.muted },
      threshold: -> row { row.threshold > row.retries },
    }

    # TODO: Add a filter to show only errored checks (not OK)
    def for_display(order_by: :status, order_dir: :asc, filters: [])
      all_results = all

      filters.each do |filter|
        all_results = all_results.reject!(&FILTERS[filter])
      end

      if order_dir == :asc
        all_results.sort_by! &order_by
      elsif order_dir == :desc
        all_results.sort! { |a, b| b.public_send(order_by) <=> a.public_send(order_by) }
      else
        raise ArgumentError, "Bad parameter for order_dir"
      end

      all_results.group_by(&:muted)
    end

    private

    def fetch_events
      sensu =
        # TODO: Have a config for the URL
        Faraday.new(url: 'http://localhost:4567') do |faraday|
          faraday.response :json
          faraday.headers['Content-Type'] = 'application/json'
          faraday.adapter Faraday.default_adapter
        end

      sensu.get('/events').body
    end
  end

  def status_text
    STATUS_NAMES[@status]
  end
end
