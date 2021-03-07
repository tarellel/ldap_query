# frozen_string_literal: true

module LdapQuery
  # If used with a rails application, this allows the the script to pull ldap credentials from Rails.application.credentials
  class RailsCredentials
    attr_accessor :credentials

    # Used to grab the applications encrypted credentials with the ldap key
    #
    # @return [Hash]
    def self.credentials
      return EMPTY_HASH unless rails?

      @_credentials ||= Rails.application.credentials[:ldap]
    rescue
      # In case an older rails application is used were `Rails.application.credentials` isn't defined
      raise(CredentialsError, 'Rails.application.credentials could not be found')
    end

    # Used to verify `Rails.application` exists within the codebase
    #
    # @return [Boolean]
    def self.rails?
      (defined?(Rails) && Rails.respond_to?(:application))
    end
  end
end
