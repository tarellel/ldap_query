# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ldap_query/version'

Gem::Specification.new do |spec|
  spec.name          = 'ldap_query'
  spec.version       = LdapQuery::VERSION
  spec.authors       = ['Brandon Hicks']
  spec.email         = ['tarellel@gmail.com']

  spec.summary       = 'Used to easily query LDAP to authenticate or do a query for matching user attributes'
  spec.description   = 'Easily generate LDAP connections and queries without having to learn how to build an LDAP connection with ruby.'
  spec.homepage      = "https://github.com/tarellel/ldap_query"
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # spec.files         = Dir.glob('lib/**/*')
  spec.files = `git ls-files | grep -Ev '^(test|myapp|examples)'`.split("\n")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('activesupport', '>= 5.0')
  spec.add_dependency('net-ldap', '~> 0.16')
  spec.add_development_dependency('bundler', '>= 1.17', '< 3.0')
  spec.add_development_dependency('rake', '~> 13')
  spec.add_development_dependency('rspec', '~> 3.9')
end
