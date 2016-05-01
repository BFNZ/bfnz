# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :selenium

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
    Rails.application.load_seed

    WebMock.disable_net_connect!(:allow_localhost => true)
    # stub_request(:any, 'api.addressfinder.nz').
    #   to_return(%Q{/**/reqwest_1427708603773({"completions":[{"a":"5 Oxford Avenue, Kamo, Whangarei 0112","pxid":"2-.9.2U.4.1Z.5","v":1},{"a":"5 Oxford Court, Paraparaumu 5032","pxid":"2-.F.w.5.1Z.3","v":1},{"a":"5 Oxford Crescent, Ebdentown, Upper Hutt 5018","pxid":"2-.F.1P.8.M.q","v":1},{"a":"5 Oxford Road, Manurewa, Auckland 2102","pxid":"2-.1.6.1E.2X.C","v":1},{"a":"5 Oxford Road, Rangiora 7400","pxid":"2-.3.3L.2.4k.D","v":1},{"a":"5 Oxford Road, Springvale, Wanganui 4501","pxid":"2-.6.2F.C.V.4","v":1},{"a":"5 Oxford Street, Balclutha 9230","pxid":"2-.A.E.1.2n.8","v":1},{"a":"5 Oxford Street, Fairfield, Hamilton 3214","pxid":"2-.E.Y.C.d.V","v":1},{"a":"5 Oxford Street, Hampstead, Ashburton 7700","pxid":"2-.3.D.4.Q.19","v":1},{"a":"5 Oxford Street, Hokowhitu, Palmerston North 4410","pxid":"2-.6.1I.7.10.a","v":1}], "paid":false})})
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:all, type: :feature) do
    DatabaseCleaner.strategy = :truncation, {except: %w{items territorial_authorities}}

  end

  config.before(:each, js: true) do
    Capybara.page.driver.browser.manage.window.maximize
  end
end
