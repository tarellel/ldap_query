# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LdapQuery::RailsCredentials do
  describe 'without rails' do
    it { expect(described_class.credentials).to eq({}) }
    it { expect(described_class.rails?).to be_falsey }
  end
end