RSpec.describe LanggraphPlatform::Client do
  describe '#initialize' do
    it 'creates a client with API key' do
      client = LanggraphPlatform::Client.new(api_key: 'test-key')
      expect(client.configuration.api_key).to eq('test-key')
    end

    it 'creates a client with custom base URL' do
      client = LanggraphPlatform::Client.new(
        api_key: 'test-key',
        base_url: 'https://custom.api.com'
      )
      expect(client.configuration.base_url).to eq('https://custom.api.com')
    end

    it 'raises error when API key is missing' do
      expect do
        LanggraphPlatform::Client.new
      end.to raise_error(LanggraphPlatform::Errors::UnauthorizedError)
    end

    it 'initializes all resource objects' do
      client = test_client
      expect(client.assistants).to be_a(LanggraphPlatform::Resources::Assistants)
      expect(client.threads).to be_a(LanggraphPlatform::Resources::Threads)
      expect(client.runs).to be_a(LanggraphPlatform::Resources::Runs)
      expect(client.crons).to be_a(LanggraphPlatform::Resources::Crons)
      expect(client.store).to be_a(LanggraphPlatform::Resources::Store)
      expect(client.mcp).to be_a(LanggraphPlatform::Resources::Mcp)
    end
  end

  describe '#configure' do
    it 'allows configuration changes' do
      client = test_client

      client.configure do |config|
        config.timeout = 60
        config.retries = 5
      end

      expect(client.configuration.timeout).to eq(60)
      expect(client.configuration.retries).to eq(5)
    end
  end
end
