require 'spec_helper'
require 'time'
require 'json'
require 'rikudo'
require 'rack/test'

describe '/' do
  include Rack::Test::Methods
  let(:app) { Rikudo }
  before {get '/'}
  it('returns 200 OK') { expect(last_response).to be_ok }
  it('has "Active checks" title') { expect(last_response.body).to include('Active checks') }
end
