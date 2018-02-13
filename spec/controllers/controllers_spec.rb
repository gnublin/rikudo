require 'spec_helper'
require 'time'
require 'json'
require 'rikudo'
require 'rack/test'

describe Rikudo do
  include Rack::Test::Methods

  let(:app) { Rikudo }

  before do
    data = JSON.parse(IO.read('sample.json'))
    allow(Event).to receive(:fetch_events).and_return(data)
  end

  describe '/' do
    before { get '/' }

    it('returns 200 OK') { expect(last_response).to be_ok }
    it('has "Active checks" title') { expect(last_response.body).to include('Active checks') }
  end

  describe '/?muted=0' do
    before { get '/', muted: 0 }

    it('returns 200 OK') { expect(last_response).to be_ok }
    it('does not have "Active checks" title') { expect(last_response.body).not_to include('Active checks') }
    it('shows active checks') { expect(last_response.body).to include('service-filebeat') }
    it('hides muted checks') { expect(last_response.body).not_to include('service-logstash') }
  end
end
