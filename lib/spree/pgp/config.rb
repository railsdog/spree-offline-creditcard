module Spree
  module Pgp
    # Singleton class to access the Pgp configuration object (PgpConfiguration.first by default) and it's preferences.
    #
    # Usage:
    #   Spree::Pgp::Config[:foo]                  # Returns the foo preference
    #   Spree::Pgp::Config[]                      # Returns a Hash with all the Pgp preferences
    #   Spree::Pgp::Config.instance               # Returns the configuration object (PgpConfiguration.first)
    #   Spree::Pgp::Config.set(preferences_hash)  # Set the Pgp preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess
    
      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          PgpConfig.find_or_create_by_name("Default Pgp configuration")
        end
      end
    end
  end
end