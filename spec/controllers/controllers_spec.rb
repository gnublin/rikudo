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
end
