# frozen_string_literal: true

# Used for creating exceptions with the Ldap connections and configuration
module LdapQuery
  class Error < StandardError; end

  class AttributeError < Error; end
  class ConnectionError < Error; end
  class CredentialsError < Error; end
  class ConfigError < Error; end
end
