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
    before { get '/', **params }

    describe 'without parameters' do
      let(:params) { {} }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('has "Active checks" title') { expect(last_response.body).to include('Active checks') }
    end

    describe 'with muted filter' do
      let(:params) { { filters: 'muted' } }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('does not have "Active checks" title') { expect(last_response.body).not_to include('Active checks') }
    end

    describe 'with muted filter' do
      let(:params) { { filters: 'muted' } }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('does not have "Active checks" title') { expect(last_response.body).not_to include('Active checks') }
      it('does not have "logstash00-test" host') { expect(last_response.body).not_to include('logstash00-test')}
    end

    # TODO: Complete tests
  end
end
