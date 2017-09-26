require 'faraday'
require 'faraday_middleware'

class Result
  attr_reader :status, :muted, :host, :retries, :last_ok, :last_failure, :name

  def initialize(sensu_results)
    @status = sensu_results['check']['status']
    @muted = false
    @host = sensu_results['client']
    @retries = sensu_results['check']['occurences']
    @last_ok = sensu_results['check']['executed']
    @last_failure = sensu_results['check']['issued']
    @name = sensu_results['check']['name']
  end

  def self.all
    sensu = Faraday.new(url: 'http://localhost:4567') do |faraday|
      faraday.response :json
      faraday.headers['Content-Type'] = 'application/json'
      faraday.adapter Faraday.default_adapter
    end
    results = sensu.get('/results').body

    results.select! { |t| t['check']['status'] != 0 }
    results.map! do |t|
      Result.new(t)
    end

    results
  end

end