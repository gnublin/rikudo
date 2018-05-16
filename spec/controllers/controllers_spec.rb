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
      it('does not have "logstash00-test" host') { expect(last_response.body).not_to include('logstash00-test') }
    end

    describe 'with status:Warning filter' do
      let(:params) { { filters: 'status:Warning' } }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('does not have "Active checks" title') { expect(last_response.body).not_to include('Active checks') }
      it('has "Warning" word') { expect(last_response.body).to include('Warning') }
      it('does not have "Critical" word') { expect(last_response.body).not_to include('Critical') }
    end

    describe 'with status:Critical filter' do
      let(:params) { { filters: 'status:Critical' } }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('does not have "Active checks" title') { expect(last_response.body).not_to include('Active checks') }
      it('has "Critical" word') { expect(last_response.body).to include('Critical') }
      it('does not have "Warning" word') { expect(last_response.body).not_to include('Warning') }
    end

    describe 'with status:Unknown filter' do
      let(:params) { { filters: 'status:Unknown' } }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('has "Active checks" title') { expect(last_response.body).to include('Active checks') }
      it('has "Muted checks" title') { expect(last_response.body).to include('Muted checks') }
      it('has "Unknown" word') { expect(last_response.body).to include('Unknown') }
      it('does not have "Critical" word') { expect(last_response.body).not_to include('Critical') }
      it('does not have "Warning" word') { expect(last_response.body).not_to include('Warning') }
    end

    describe 'with status:Unknown and muted filter' do
      let(:params) { { filters: 'status:Unknown,muted' } }

      it('returns 200 OK') { expect(last_response).to be_ok }
      it('has "Active checks" title') { expect(last_response.body).not_to include('Active checks') }
      it('has "Muted checks" title') { expect(last_response.body).not_to include('Muted checks') }
      it('has "Unknown" word') { expect(last_response.body).to include('Unknown') }
      it('does not have "Critical" word') { expect(last_response.body).not_to include('Critical') }
      it('does not have "Warning" word') { expect(last_response.body).not_to include('Warning') }
    end
  end
end
