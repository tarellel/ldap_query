# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LdapQuery::Query do
  describe 'attaching a filter' do
    it { expect(described_class.attach_filter({ attr: 'cn', val: 'bob' }).to_s).to eq('(cn=bob)') }
    it { expect(described_class.attach_filter({ attr: 'stevey', val: 'bob' }).to_s).to eq('(stevey=bob)') }
  end

  describe 'ensure_limit_set' do
    it { expect(described_class.ensure_limit_set).to eq(20) }
    it { expect(described_class.ensure_limit_set(-10)).to eq(20) }
    it { expect(described_class.ensure_limit_set(0)).to eq(20) }
    it { expect(described_class.ensure_limit_set(2)).to eq(2) }
    it { expect(described_class.ensure_limit_set('a')).to eq(20) }
  end
end