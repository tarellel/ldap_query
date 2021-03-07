# frozen_string_literal: true

require 'simplecov'
require 'simplecov-tailwindcss'

SimpleCov.start do
  add_filter('/bin/')
  add_filter('/cache/')
  add_filter('/docs/')
  add_filter('/lib/ldap_query/version.rb')
  add_filter('/spec/support/')
end
SimpleCov.minimum_coverage(75)
SimpleCov.use_merging(false)
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::TailwindFormatter
])
