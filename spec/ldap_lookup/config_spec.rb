# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LdapQuery::Config do

  describe 'without valid hash' do
    it { expect { described_class.new }.to raise_error(ArgumentError) }
    it { expect { described_class.new({}) }.to raise_error(ArgumentError) }
    it { expect { described_class.new(123) }.to raise_error(ArgumentError) }
  end

  describe 'should convert specific keys/values to symbols' do
    subject(:config) { config = described_class.new({ david: 'friends', 'base' => '123', username: 'foo', password: 'bar', method: 'simple', host: 'company.tld' }) }

    it { expect(config.method).to eq(:simple) }
  end

  describe 'required keys missing' do
    it 'should raise with ' do
      expect { described_class.new({ port: 123, david: 'friends' }) }.to raise_error(LdapQuery::ConfigError, 'required config values ([:base, :username, :password, :host, :port]) can not be nil')
    end
  end
end