# frozen_string_literal: true

require 'net-ldap'

module LdapQuery
  # Used to build LDAP filters and query the host based on the configuration passed
  class Query
    REQUIRED_QUERY_ATTRS = %i[attr val].freeze
    FILTER_METHODS = %i[cn displayname memberof object_class mail samaccountname person].freeze

    # Establish LDAP connection, apply filters, and return results
    #
    # @param credentials [Hash]
    # @opts attr [String] The attribute field in ldap that you want to query again
    # @opts val [String] the value you want to query ldap with
    # @opts limit [Integer] the number of entries to limit the query to
    # @opts wildcard [Boolean] used to determine if the filter should be wildcard match
    def self.perform(credentials, attr: nil, val: nil, limit: 20, wildcard: false)
      raise(AttributeError, 'a valid attribute name and value are required in order to make an ldap query.') if attr.nil? || val.nil?

      config = LdapQuery::Config.new(credentials)
      filter = attach_filter({ attr: attr, val: val }, wildcard: wildcard)
      ldap = ldap_connection(config.hash)
      entries = ldap.search(filter: filter, size: ensure_limit_set(limit))
      entries.nil? ? EMPTY_ARRAY : sort_by_displayname(entries)
    end

    # Used to associate and LDAP filter to the connection based on the attr and value supplied
    #
    # @param query [Hash<{attr: attr, val: :val}]
    # @attr wildcard [Boolean] used to determine if the filter should be wildcard match
    def self.attach_filter(query, wildcard: false)
      if FILTER_METHODS.include?(query[:attr].to_sym)
        # Add the filter for the specific
        LdapQuery::Filter.public_send(query[:attr], query[:val], wildcard: wildcard)
      else
        LdapQuery::Filter.other(query[:attr], query[:val], wildcard: wildcard)
      end
    end

    # Establish an ldap connection with the supplied credentials
    #
    # @param credemntials [Hash]
    # @return [Net::LDAP]
    def self.ldap_connection(credentials)
      LdapQuery::Connection.new(credentials).link
    end

    ########################################
    # Sorters
    ########################################
    # Sort results by their displayanmes
    # @param [Hash,Struct, Interface<Net::Ldap>]
    # @return [Hash]
    def self.sort_by_displayname(entries = [])
      return EMPTY_ARRAY if entries.blank?

      # the begin/rescue is in place because some service accounts are missing the displayname and causes issues when sorting
      # => if they are missing this attribute they should be sorted last ie: the 'zzzzzzzzzzzz' value
      entries.sort_by do |entry|
        entry.respond_to?(:displayname) ? entry&.displayname.first.downcase : 'zzzzzzzzzzz'
      end
    end

    def self.ensure_limit_set(limit = 20)
      return limit if limit.is_a?(Integer) && limit.positive?

      20
    end
  end
end
