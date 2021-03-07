# frozen_string_literal: true

module LdapQuery
  # Used to authenticate a users LDAP credentials to a user in LDAP
  class Authenticate
    attr_accessor :config, :connection

    REQUIRED_CONNECTION_KEYS = %i[host username password base].freeze

    # Initialzile an ldap connection for authenticating a user
    #
    # @params credentials [Hash]
    def initialize(credentials = {})
      establish_connection(credentials)
    end

    # Authenticate the user again ldap with the supplied username/password
    #
    # @param username [String]
    # @param password [String]
    # @return [Boolean, Hash, Net::Ldap]
    def auth_user(username, password)
      return false if username.nil? || password.nil?

      response = @connection.link.bind_as(base: @config.base,
                                          size: 1,
                                          filter: LdapQuery::Filter.auth(username),
                                          password: password)
      # if no user was found return false, otherwise return the user
      (response && response[0]) ? response : false
    end

    private

    # Establish an ldap connection without fulling binding a connection yet
    #
    # @params credentials [Hash]
    def establish_connection(credentials = {})
      raise_keys_error if credentials.blank? || !required_credentials_supplied?(credentials)

      @config = LdapQuery::Config.new(credentials)
      @connection = LdapQuery::Connection.new(@config.auth_hash, type: :auth)
      @connection.link.auth(@config.username, @config.password)
    rescue
      raise(ConnectionError, 'Failure connecting to LDAP host')
    end

    # Verify if the required encryption keys have been supplied
    #
    # @return [Boolean]
    def required_credentials_supplied?(credentials = {})
      # Verify all reqiured credentail values have been supplied for the LDAP connection
      REQUIRED_CONNECTION_KEYS.all? { |req_key| credentials.key?(req_key) }
    end

    # Raise an exception if any of the credentials are missing any key/value for authenticating a user
    def raise_keys_error
      raise(CredentialsError, "The following credentials attributes are required: #{REQUIRED_CONNECTION_KEYS}")
    end
  end
end
