# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LdapQuery::Filter do
  describe 'should return filter string' do
    it { expect(described_class.cn('fooBar').to_s).to eq('(cn=fooBar)') }
    it { expect(described_class.person('fooBar').to_s).to eq('(&(cn=fooBar)(objectClass=person))') }
    it { expect{ described_class.person }.to raise_error(ArgumentError) }

    it { expect(described_class.other('someAttr', 'fooBar').to_s).to eq('(someAttr=fooBar)')}
  end


  describe 'clean_str' do
    it { expect(described_class.cn('    bob jones').to_s).to eq('(cn=bob jones)') }
    it { expect(described_class.cn('    bob jones', wildcard: true).to_s).to eq('(cn=*bob*jones*)') }

    # using custome attr && value
    it { expect(described_class.other(:attr, 'misc').to_s).to eq('(attr=misc)') }
    it { expect(described_class.other(:attr, 'misc', wildcard: true).to_s).to eq('(attr=*misc*)') }
  end
end