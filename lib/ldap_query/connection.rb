# frozen_string_literal: true

require 'net/ldap'

module LdapQuery
  # For establishing an LDAP connection (binding LDAP connection)
  class Connection
    attr_accessor :link

    REQUIRED_KEYS = %i[host port base auth].freeze

    # Used for creating the initial Ldap connection for querying with supplied parameters
    #
    # @param credentials [Hash]
    # @return [Interface <Net::Ldap>]
    def initialize(credentials, type: :basic)
      if type == :auth
        credentials = filter_auth_credentials(credentials)
      else
        valid_credentials?(credentials)
      end
      @link = bind_connection(credentials)
    end

    private

    # Filter out all parameter keyus/values and only keep the required auth keys
    #
    # @param credentials [Hash]
    # @return [Hash]
    def filter_auth_credentials(credentials)
      auth_keys = %i[host port encryption].freeze
      credentials.select { |key, _v| auth_keys.include?(key) }.freeze
    end

    # Validate all required keys have been included
    #
    # @param credentials [Hash]
    # @return [Hash]
    def valid_credentials?(credentials)
      credentials_error if !credentials.is_a?(Hash) || credentials.empty?
      required_credentials?(credentials)
    end

    # Validate all required auth credentials have been supplied
    #
    # @param credentials [Hash]
    # @return [Hash]
    def required_credentials?(credentials = {})
      credentials_error unless REQUIRED_KEYS.all? { |k| credentials[k] }
    end

    # Raise an exception error if not all LDAP credentials have been included
    def credentials_error
      raise(CredentialsError, 'valid ldap credentials must be passed in order to establish a connection')
    end

    # Create LDAP connection string
    #
    # @params credentials [Hash]
    # @return [Interface <Net::Ldap>]
    def bind_connection(credentials)
      Net::LDAP.new(credentials)
    rescue
      raise(ConnectionError, 'Failure connecting to LDAP host')
    end
  end
end
