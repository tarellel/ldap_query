# frozen_string_literal: true

require_relative 'ldap_query/version'
require 'active_support'
require 'active_support/core_ext/object/blank' # Used so methods like .blank? will be available
require_relative 'ldap_query/ldap_query'
require_relative 'ldap_query/authenticate'
require_relative 'ldap_query/config'
require_relative 'ldap_query/connection'
require_relative 'ldap_query/error'
require_relative 'ldap_query/filter'
require_relative 'ldap_query/ldap_helper'
require_relative 'ldap_query/rails_credentials'
require_relative 'ldap_query/query'

require_relative 'ldap_query/railtie' if defined?(::Rails) || defined?(Rails)
