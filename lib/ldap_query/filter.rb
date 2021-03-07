# frozen_string_literal: true

require 'net-ldap'

module LdapQuery
  # Used to create return LDAP query stings depending on what attribute you want to filter
  class Filter
    # Used to create an LDAP filter for the specified LDAP attribute
    #
    # @param str [String]
    # @attr wildcard [Boolean] used to determine if the filter should be wildcard match
    # @example:
    #   LdapQuery::Filter.cn('mscott')
    # @example:
    #   LdapQuery::Filter.memberof('CN=somegroup,OU=OrganizationalUnit,DC=company.tld)
    %w[cn displayname mail memberof samaccountname].each do |attr|
      define_singleton_method(attr) do |str, wildcard: false|
        Net::LDAP::Filter.eq(attr, clean_str(str, wildcard: wildcard))
      end
    end

    # Generally most ldap queries are again person, sometimes other types will be used for service accounts
    #
    # @param str [String]
    # @attr wildcard [Boolean] used to determine if the filter should be wildcard match
    def self.object_class(str = 'person', wildcard: false)
      Net::LDAP::Filter.eq('objectClass', clean_str(str, wildcard: wildcard))
    end

    # Used to filter LDAP accounts against a custom attribute and valuess
    #
    # @param attr [String] a custom attribute to query again
    # @param val [String] a user specified value to filter against
    # @attr wildcard [Boolean] used to determine if the filter should be wildcard match
    def self.other(attr, val, wildcard: false)
      Net::LDAP::Filter.eq(attr, clean_str(val, wildcard: wildcard))
    end

    # Filter user based on CN attribute (CN is a required attribute)
    #
    # @param username [String]
    # @attr wildcard [Boolean] used to determine if the filter should be wildcard match
    def self.person(username, wildcard: false)
      cn_filter = LdapQuery::Filter.cn(username, wildcard: wildcard)
      user_filter = LdapQuery::Filter.object_class
      Net::LDAP::Filter.join(cn_filter, user_filter)
    end

    # Filter used to authenticate a validate CN & Person entry
    #
    # @param username [String]
    def self.auth(username)
      Net::LDAP::Filter.join(cn(username), object_class)
    end

    # If you want to wildcard it this turns all spaces into '*' and adds '*' at the beginning and end of the str as well
    #
    # @param str [String] the query str
    # @attr wildcard [Boolean] used to determine if the filter should be wildcard match
    # @return [String] either the original str, or a value prepared to wildcard when hitting ldap
    def self.clean_str(str, wildcard: false)
      str = str&.strip
      return str unless wildcard && str.is_a?(String)

      str = str.split(/\s/).compact.join('*').squeeze('*')
      "*#{str}*"
    end
  end
end
