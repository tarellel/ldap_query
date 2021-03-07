# frozen_string_literal: true

module LdapQuery
  # Inject the specified helpers into the rails application helpers and controllers for ease of use
  class Railtie < Rails::Railtie
    initializer 'ldap.configure_rails_initialization' do |app|
      app.config.to_prepare do
        # Allow the LDAP gem to be acessible by default from helpers, controllers, and models

        # Add the LdapQuery helpers to the rails applications controllers
        if defined?(ApplicationController)
          ApplicationController.include(LdapQuery::LdapHelper)
        elsif defined?(ActionController::Base)
          ActionController::Base.include(LdapQuery::LdapHelper)
        end
        # Add the LdapQuery helpers to the rails applications helpers
        ApplicationHelper.include(LdapQuery::LdapHelper) if defined?(ApplicationHelper)

        # Allow the LdapQuery helpers to be used in ActiveRecord/Models
        if defined?(ApplicationRecord)
          ApplicationRecord.include(LdapQuery::LdapHelper)
        elsif defined?(ActiveRecord::Base)
          ActiveRecord::Base.include(LdapQuery::LdapHelper)
        end
      end
    end
  end
end
