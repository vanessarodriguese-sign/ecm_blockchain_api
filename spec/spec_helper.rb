# frozen_string_literal: true

require "ecm_blockchain_api"
require 'webmock/rspec'
require 'factory_bot'
require 'shoulda-matchers'
require "active_support"
require 'shoulda/matchers'
require './spec/support/helpers/asset_helper'
WebMock.disable_net_connect!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.include FactoryBot::Syntax::Methods
  config.include AssetHelper

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:each) do
    ECMBlockchain.access_token = "abc123"
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Keep as many of these lines as are necessary:
    with.library :active_record
    with.library :active_model
  end
end
