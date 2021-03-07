# frozen_string_literal: true

require 'active_support/core_ext/hash'

module LdapQuery
  # Used to validate and filter credentials for establishing an LDAP connection
  class Config
    DEFAULT_CONFIG = { port: 389,       # Usually 389 && 636
                       encryption: nil,
                       base: nil,       # 'dc=company,dc=tld'
                       username: nil,
                       password: nil,
                       method: :simple }.freeze
    ALLOWED_KEYS = %i[base encryption host method port username password].freeze
    ALLOWED_KEYS.each { |attr| attr_accessor attr }

    # Required to be assigned and not have nil valuess
    REQUIRED_KEYS = %i[base username password host port].freeze

    # Attributes whos values are required to by symbols for the LDAP gem
    VALS_REQUIRED_TO_BE_SYMBOLS = %i[encryption method].freeze

    # Build and validate the configuration hash supplied for creating an LDAP connection
    #
    # @param config [Hash]
    # @return [Hash]
    def initialize(config = {})
      raise(ArgumentError, "the following attributes are required for an ldap connection #{REQUIRED_KEYS}") unless config.is_a?(Hash) && !config.blank?

      map_variables(validate_keys(cleanup_hash(defaults(config))))
    end

    # Build a hash out of the provided config to establish an LDAP connection
    #
    # @return [Hash]
    def hash
      @hash ||= { host: @host, port: @port, base: @base, encryption: @encryption }.merge(credentials_hash).freeze
    end

    # Build a hash of required config for authenticating a user against ldap
    #
    # @return [Hash]
    def auth_hash
      @auth_hash ||= { host: @host, port: @port, encryption: @encryption }.freeze
    end

    private

    # Build a hash with the connections username, password, and method for the LDAP connection
    #
    # @return [Hash]
    def credentials_hash
      raise(ConfigError, 'config username or password are nil') unless @username && @password

      credentials_hash = { username: @username, password: @password }.freeze
      credentials_hash = credentials_hash.merge({ method: @method }) if @method
      { auth: credentials_hash }.freeze
    end

    # Associate all the config hash key/values as instance variables for easy reference
    #
    # @param config_hash [Hash]
    def map_variables(config_hash = {})
      ALLOWED_KEYS.each do |attr|
        instance_variable_set("@#{attr}", config_hash[attr])
      end
    end

    # Set default keys/values if not supplied in the config hash
    #
    # @param config [Hash]
    # @return [Hash]
    def defaults(config = {})
      config.reverse_merge(DEFAULT_CONFIG).freeze
    end

    # Loop through the supplied config hash, make all keys unique and symbolzied, and symbolize the specified values
    #
    # @param config_hash [Hash]
    # @return [Hash]
    def cleanup_hash(config_hash = {})
      # ensure keys like :key and 'key' are considered the same
      # this is similar to running .uniq on an array
      config_hash.with_indifferent_access.symbolize_keys.tap do |config|
        VALS_REQUIRED_TO_BE_SYMBOLS.each do |key|
          config[key] = config[key].to_sym if config[key]
        end
      end
    end

    # Validate all required keys have been included
    #
    # @param config_hash [Hash]
    # @return [Boolean]
    def required_keys_included?(config_hash = {})
      REQUIRED_KEYS.all? do |key|
        raise(ConfigError, "config key #{key} is required to be set.") unless config_hash.key?(key)
      end
    end

    # Ensure that a handful of parameters have actual values and not just nil or ''
    #
    # @param config_hash [Hash]
    # @return [Boolean]
    def required_vals_given?(config_hash)
      raise(ConfigError, "required config values (#{REQUIRED_KEYS}) can not be nil") unless REQUIRED_KEYS.all? { |k| !config_hash[k].nil? }
    end

    # Filter out and remove unneeded configuration hash keys
    #
    # @param config_hash [Hash]
    # @return [Hash]
    def remove_unknown_keys(config_hash)
      config_hash.select { |key, _v| ALLOWED_KEYS.include?(key) }.freeze
    end

    # Validate and cleanup all supplied configuration key/values
    #
    # @param config_hash [Hash]
    def validate_keys(config_hash = {})
      required_keys_included?(config_hash)
      required_vals_given?(config_hash)
      remove_unknown_keys(config_hash)
    end
  end
end
