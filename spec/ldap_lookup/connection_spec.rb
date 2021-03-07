# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LdapQuery::Connection do
  describe 'without credentials' do
    it { expect { described_class.new({}) }.to raise_error(LdapQuery::CredentialsError) }
    it { expect { described_class.new({ username: 'foobar', password: 'password' })}.to raise_error(LdapQuery::CredentialsError) }
  end

  describe 'valid connection' do
    let(:ldap_conn) { described_class.new({ port: 369, base: 'dc=company,dc=tld', host: 'company.tld', auth: { username: 'foobar', password: 'password' } }) }
    it { expect(ldap_conn.link.class.name).to eq('Net::LDAP')}
  end
end
