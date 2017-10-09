require 'spec_helper'
require 'models/event'
require 'time'

describe Event do
  let :sensu do
    {
      'check' => {
        'status' => 1,
        'issued' => 1483264800,
        'name' => 'bar'
      },
      'silenced' => false,
      'client' => { 'name' => 'foo' },
      'occurrences' => 3,
      'last_ok' => 1483261200,
    }
  end

  describe '#initialize' do
    subject { Event.new(sensu) }

    it('sets status') { expect(subject.status).to eql 1 }
    it('sets muted') { expect(subject.muted).to be false }
    it('sets host') { expect(subject.host).to eql 'foo' }
    it('sets retries') { expect(subject.retries).to eql 3 }
    it('sets last_ok') { expect(subject.last_ok).to eql Time.parse('2017-01-01 10:00') }
    it('sets last_failure') { expect(subject.last_failure).to eql Time.parse('2017-01-01 11:00') }
    it('sets name') { expect(subject.name).to eql 'bar' }
  end
end
