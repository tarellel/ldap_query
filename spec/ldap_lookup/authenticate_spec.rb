# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LdapQuery::Authenticate do
  describe '' do
    it { expect { described_class.new({}) }.to raise_error(LdapQuery::ConnectionError) }
  end
end