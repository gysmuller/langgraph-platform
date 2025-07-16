RSpec.describe LanggraphPlatform::Resources::Assistants do
  let(:client) { instance_double(LanggraphPlatform::BaseClient) }
  let(:assistants) { described_class.new(client) }

  describe '#create' do
    it 'creates an assistant' do
      response = {
        'assistant_id' => 'test-id',
        'graph_id' => 'test-graph',
        'config' => {},
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => {}
      }

      expect(client).to receive(:post).with('/assistants', {
                                              graph_id: 'test-graph',
                                              config: {},
                                              metadata: {}
                                            }).and_return(response)

      assistant = assistants.create(graph_id: 'test-graph')
      expect(assistant).to be_a(LanggraphPlatform::Models::Assistant)
      expect(assistant.assistant_id).to eq('test-id')
      expect(assistant.graph_id).to eq('test-graph')
    end
  end

  describe '#find' do
    it 'finds an assistant by ID' do
      response = {
        'assistant_id' => 'test-id',
        'graph_id' => 'test-graph',
        'config' => {},
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => {}
      }

      expect(client).to receive(:get).with('/assistants/test-id').and_return(response)

      assistant = assistants.find('test-id')
      expect(assistant).to be_a(LanggraphPlatform::Models::Assistant)
      expect(assistant.assistant_id).to eq('test-id')
    end
  end

  describe '#search' do
    it 'searches for assistants' do
      response = [
        {
          'assistant_id' => 'test-id-1',
          'graph_id' => 'test-graph',
          'config' => {},
          'created_at' => '2023-01-01T00:00:00Z',
          'updated_at' => '2023-01-01T00:00:00Z',
          'metadata' => {}
        },
        {
          'assistant_id' => 'test-id-2',
          'graph_id' => 'test-graph',
          'config' => {},
          'created_at' => '2023-01-01T00:00:00Z',
          'updated_at' => '2023-01-01T00:00:00Z',
          'metadata' => {}
        }
      ]

      expect(client).to receive(:post).with('/assistants/search', {
                                              metadata: {},
                                              limit: 10,
                                              offset: 0
                                            }).and_return(response)

      results = assistants.search
      expect(results).to be_an(Array)
      expect(results.length).to eq(2)
      expect(results.first).to be_a(LanggraphPlatform::Models::Assistant)
    end
  end

  describe '#delete' do
    it 'deletes an assistant' do
      expect(client).to receive(:delete).with('/assistants/test-id')

      result = assistants.delete('test-id')
      expect(result).to be true
    end
  end
end
