[![LdapQuery][rubygems-downloads]][rubygems-link]
[![Gem Version][rubygems-version]][rubygems-link]
[![MIT License][license-shield]][license-url]

# LdapQuery

I used to make querying LDAP with a ruby or rails application an easy process rather than pain trying to figure out how to bind the connections. Build a LDAP filter and querying the LDAP host for matching results.

It was taken into account that not all ruby scripts are part of a rails application, so you can either pass it a credentials hash. But if you're making the queries from a rails application with and haven't passed a credentials hash it resolves to looking for an entry in your encrypted credentials with an ldap key.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ldap_query'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ldap_query

## Usage

If you're using this gems functionality from a rails application you'll want to either add the following to your encrypted credentials file or pass the credentials to your query helpers as an optional parameter.

```yaml
ldap:
  host: company_host.tld
  base: DC=company,DC=org,DC=tld
  username: cn=Common,OU=Organization,DC=Domain,DC=tld
  password: password123
  port: 636
  encryption: simple_tls
  method: simple
```

_(port, encryption, and method are optional)_

If using this gem in a rails application there are helpers available that you can called from your controllers, views/helpers, and/or models.

#### Rails Helpers

```ruby
search_ldap_by_username(str)  # seaches for a matching `cn`

search_ldap_by_name(str)  # searches for a matching `displayname`

search_ldap_by_group(str) # tries to find a match against a matching `memberof`

search_ldap_by_mail(str)  # matches against the ldap users mail attribute

search_ldap_by_other(attr: 'key', val: 'val') # matches against the specified ldap attribute and value

authenticate_user(username: 'jdoe', password: 'pass123')  # Bind a user against the ldap base to authenticate their credentials
```

There are 2 optional keyword parameters you can pass when using these helpers, `wildcard:` and `limit:`.

Default values

```ruby
wildcard: false # when set as false it expects an exact match
limit: 20       # default limit of ldap results returned
```

Without wildcard ldap requires an exact match like, ie if you have a user with a displayname of `John A. Doe` and you do a lookup with wildcard as false with the str `John Doe` it won't return the user. But if wildcard is set as true it compares against ldap with the value of `John*Doe`. Which _should_ match the user,

To change these values you just add the key and value to the method call.

`search_ldap_by_username('jdoe', wildcard: true)`


These helpers also allow a _(optional)_ secondary parameter to be passed to them. This secondary will be used as the ldap credential. By default the gem will pull the ldap connections credentials from your encrypted credentials, so you don't need to pass paramters, if you have set the credentials with a base key of `ldap:`. But the one case were you may need to pass the credentials is if you want to hit multiple ldap hosts/bases to grab different results.

```ruby
first_results = search_ldap_by_username('jdoe', first_host_credentials_hash)
second_results = search_ldap_by_username('jdoe', hash_host_credentials_hash)
```

#### CLI or Ruby script

But these helpers are optional and can be used in CLI or through a ruby script without having to use rails.

Jsut be sure to include the LdapQuery gem into your ruby script or terminal with the following: `require 'ldap_query'`.

The main part of build the query if using `LdapQuery::Query.perform` method. You need to ensure you pass the credentials hash, the ldap attribute you want to query againt _(ie: :cn)_ and the val you are will be querying ldap with. As see from the helper methods above you can also pass the keyword/values for `wildcard` and `limit`.

```ruby
require 'ldap_query'

# You LDAP credentials always need to be passed as hash, listed below are the required parameters
# (optional parameters include: port, method, and encryption)
credentials = { base: 'DC=company,DC=org,DC=tld', username: 'cn=Common,OU=Organization,DC=Domain,DC=tld', password: 'password123', host: 'company.tld' }

LdapQuery::Query.perform(credentials, attr: :cn, val: str)
LdapQuery::Query.perform(credentials, attr: :displayname, val: 'John Doe', limit: 3)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tarellel/ldap_query.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[license-shield]: https://img.shields.io/github/license/tarellel/ldap_query.svg?style=flat-square
[license-url]: https://github.com/tarellel/ldap_query/blob/master/LICENSE
[rubygems-downloads]: https://ruby-gem-downloads-badge.herokuapp.com/ldap_query?type=total
[rubygems-link]: https://rubygems.org/gems/ldap_query
[rubygems-version]: https://badge.fury.io/rb/ldap_query.svg