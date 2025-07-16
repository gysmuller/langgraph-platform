require 'bundler/setup'
require 'langgraph_platform'
require 'webmock/rspec'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Filter out backtrace from gems
  config.filter_gems_from_backtrace 'faraday', 'webmock'

  # Allow focusing on specific tests
  config.filter_run_when_matching :focus

  # Randomize test order
  config.order = :random
  Kernel.srand config.seed
end

# Helper method to create a test client
def test_client(api_key: 'test-api-key', base_url: 'https://api.example.com')
  LanggraphPlatform::Client.new(api_key: api_key, base_url: base_url)
end

# Helper method to load fixture data
def load_fixture(filename)
  File.read(File.join('spec', 'support', 'fixtures', filename))
end
