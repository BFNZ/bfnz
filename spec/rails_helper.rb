# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'
require 'capybara/rails'
require 'support/pages/capybara_page'
require 'selenium-webdriver'
require 'timecop'

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

# Current Firefox version not working with webdriver
# Configuration to specify an older version of firefox
# http://blog.pixarea.com/2013/02/locking-the-firefox-version-when-testing-rails-with-capybara-and-selenium/
# Older version of firefox can be found https://ftp.mozilla.org/pub/firefox/releases/47.0.1/

def driver_on_path_or_fixed
  path = `which geckodriver`
  return path.strip unless path.empty? # In this case 'geckodriver' is not on the path
  '/usr/local/bin/geckodriver'
end

Capybara.register_driver :selenium do |app|
  if ENV['DOCKERIZED']
    Capybara::Selenium::Driver.new(app, {
      browser: :remote,
      url: "http://firefox:4444/wd/hub",
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox
    })
  else
    require 'selenium/webdriver'
    Selenium::WebDriver::Firefox.driver_path = driver_on_path_or_fixed
    Capybara::Selenium::Driver.new(app, :browser => :firefox)
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.include FeatureHelpers, type: :feature
  #webdriver.firefox.bin
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

    webmock_options = { allow_localhost: true }
    if ENV['DOCKERIZED']
      ip = Socket.ip_address_list.detect{|addr| addr.ipv4_private? }.ip_address
      webmock_options[:allow] = ["firefox", ip]
    end
    WebMock.disable_net_connect!(webmock_options)
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
    if ENV['DOCKERIZED']
      ip = Socket.ip_address_list.detect{|addr| addr.ipv4_private? }.ip_address
      Capybara.server_host = ip
      Capybara.server_port = "3000"
    end
    Capybara.page.driver.browser.manage.window.maximize
  end

  config.filter_run_when_matching :focus
end
