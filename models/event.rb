require 'faraday'
require 'faraday_middleware'

class Event
  STATUS_NAMES = %w(OK Warning Critical Unknown)

  attr_reader :status, :muted, :host, :retries, :last_ok, :last_failure, :name

  def initialize(sensu_events)
    @status = sensu_events['check']['status']
    @muted = sensu_events['silenced']
    @host = sensu_events['client']['name']
    @retries = sensu_events['occurrences']
    @last_ok = Time.at(sensu_events['last_ok'])
    @last_failure = Time.at(sensu_events['check']['issued'])
    @name = sensu_events['check']['name']
  end

  def self.all
    sensu = Faraday.new(url: 'http://localhost:4567') do |faraday|
      faraday.response :json
      faraday.headers['Content-Type'] = 'application/json'
      faraday.adapter Faraday.default_adapter
    end
    events = sensu.get('/events').body

    # for dev
    # events = JSON.parse(File.read('tata.json'))

    events.map! do |t|
      Event.new(t)
    end
    events
  end

  def self.for_display
    all.sort_by(&:status).reverse.group_by(&:muted)
  end

  def status_text
    STATUS_NAMES[@status]
  end
end
