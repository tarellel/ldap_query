# frozen_string_literal: true

module LdapQuery
  # Methods to be included as helpers in the rails application
  module LdapHelper
    def self.included(base); end
    def self.extended(base); end

    # Search ldap based on users samaccountname attribute
    #
    # @param str [String] the attributes string value you want to query against
    # @param credentials [Hash]
    def search_ldap_by_username(str, credentials = {}, wildcard: false, limit: 20)
      credentials = determine_credentials(credentials)
      LdapQuery::Query.perform(credentials, attr: :cn, val: str, wildcard: wildcard, limit: limit)
    end

    # Query LDAP based on all users displayname attribute
    #
    # @param str [String] the attributes string value you want to query against
    # @params wildcard [Boolean] used to determine if the filter should be wildcard match
    def search_ldap_by_name(str, credentials = {}, wildcard: false, limit: 20)
      credentials = determine_credentials(credentials)
      LdapQuery::Query.perform(credentials, attr: :displayname, val: str, wildcard: wildcard, limit: limit)
    end

    # Query ldap based on memberof attribute
    #
    # @param str [String] the attributes string value you want to query against
    # @param credentials [Hash]
    # @params wildcard [Boolean] used to determine if the filter should be wildcard match
    def search_ldap_by_group(str, credentials = {}, wildcard: false, limit: 20)
      credentials = determine_credentials(credentials)
      LdapQuery::Query.perform(credentials, attr: :memberof, val: str, wildcard: wildcard, limit: limit)
    end

    # Query LDAP against a custome attribute and value
    #
    # @param credentials [Hash]
    # @params attr [String, Symbol] to attribute you want to query against
    # @params val [String, Symbol] the attribute vale you want to query with when filtering against ldap results
    # @params wildcard [Boolean] used to determine if the filter should be wildcard match
    def search_ldap_by_other(credentials = {}, attr: nil, val: nil, wildcard: false, limit: 20)
      raise(AttributeError, 'a valid attribute name and value must be supplied to query against') if attr.nil? || val.nil?

      credentials = determine_credentials(credentials)
      LdapQuery::Query.perform(credentials, attr: attr, val: val, wildcard: wildcard, limit: limit)
    end

    # Query ldap based on mail attribute
    #
    # @param str [String] the attributes string value you want to query against
    # @param credentials [Hash]
    # @params wildcard [Boolean] used to determine if the filter should be wildcard match
    def search_ldap_by_mail(str, credentials = {}, wildcard: false, limit: 20)
      credentials = determine_credentials(credentials)
      LdapQuery::Query.perform(credentials, attr: :mail, val: str, wildcard: wildcard, limit: limit)
    end

    # Used to authenticate a user against ldap
    #
    # @param credentials [Hash]
    # @param username [String]
    # @params password [String]
    def authenticate_user(credentials, username: nil, password: '')
      username, password = username.to_s, password.to_s
      credentials = determine_credentials(credentials)
      raise(AttributeError, 'an ldap username is required in order to authenticate.') if username.nil?

      LdapQuery::Authenticate.new(credentials).auth_user(username, password)
    end

    private

    # Determine if the helpers have had ldap credentials passed to it
    #   If not, it will attempt to grab ldap credentials from the applications encrypted credentials
    #
    # @param credentials [Hash]
    # @return [Hash]
    def determine_credentials(credentials = {})
      return credentials if credentials.is_a?(Hash) && !credentials.empty?

      rails_credentials
    end

    # Grab the applications Rails.application.credentials[:ldap]
    #
    # @return [Hash]
    def rails_credentials
      @_rails_credentials ||= LdapQuery::RailsCredentials.credentials
    end
  end
end
