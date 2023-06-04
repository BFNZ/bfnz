require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Bfnz
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Wellington'
    
    # config.eager_load_paths << Rails.root.join("extras")

    # List of classes deemed safe to load by YAML, and required by the Audited
# gem when deserialized audit records.
# As of Rails 6.0.5.1, YAML safe-loading method does not allow all classes
# to be deserialized by default: https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
  config.active_record.yaml_column_permitted_classes = [
    ActiveSupport::HashWithIndifferentAccess,
    ActiveSupport::TimeWithZone,
    ActiveSupport::TimeZone,
    Date,
    Time,
    Symbol
  ]
  end
end
