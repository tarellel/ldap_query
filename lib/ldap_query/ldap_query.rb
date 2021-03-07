# frozen_string_literal: true

# Used to initialize and container the LdapQuery modules
module LdapQuery
  attr_accessor :ldap, :config

  EMPTY_ARRAY = [].freeze
  EMPTY_HASH = {}.freeze

  @config = {}

  # Reconfigure the LdapQuery credential configuration
  #
  # @param config_hash [Hash]
  # @return [Class <LdapQuery::Config>]
  def self.configure(config_hash = {})
    raise(ConfigError, 'a valid configuration hash must be passed.') unless config_hash.is_a?(Hash)

    # if new a new config_hash hash been passed, create a new Config instance
    @config = LdapQuery::Config.new(config_hash) unless config_hash.empty?
    @config
  end
end
