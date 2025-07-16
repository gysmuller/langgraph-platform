RSpec.describe LanggraphPlatform::Models::Assistant do
  let(:attributes) do
    {
      'assistant_id' => 'test-id',
      'graph_id' => 'test-graph',
      'config' => { 'recursion_limit' => 10 },
      'created_at' => '2023-01-01T00:00:00Z',
      'updated_at' => '2023-01-01T00:00:00Z',
      'metadata' => { 'version' => '1.0' },
      'version' => 1,
      'name' => 'Test Assistant',
      'description' => 'A test assistant'
    }
  end

  let(:assistant) { described_class.new(attributes) }

  describe '#initialize' do
    it 'initializes with attributes' do
      expect(assistant.assistant_id).to eq('test-id')
      expect(assistant.graph_id).to eq('test-graph')
      expect(assistant.config).to eq({ 'recursion_limit' => 10 })
      expect(assistant.metadata).to eq({ 'version' => '1.0' })
      expect(assistant.version).to eq(1)
      expect(assistant.name).to eq('Test Assistant')
      expect(assistant.description).to eq('A test assistant')
    end

    it 'parses timestamps' do
      expect(assistant.created_at).to be_a(Time)
      expect(assistant.updated_at).to be_a(Time)
    end

    it 'handles nil timestamps' do
      attrs = attributes.merge('created_at' => nil, 'updated_at' => nil)
      assistant = described_class.new(attrs)

      expect(assistant.created_at).to be_nil
      expect(assistant.updated_at).to be_nil
    end

    it 'defaults metadata to empty hash' do
      attrs = attributes.reject { |k, _| k == 'metadata' }
      assistant = described_class.new(attrs)

      expect(assistant.metadata).to eq({})
    end
  end

  describe '#to_h' do
    it 'converts to hash' do
      hash = assistant.to_h

      expect(hash[:assistant_id]).to eq('test-id')
      expect(hash[:graph_id]).to eq('test-graph')
      expect(hash[:config]).to eq({ 'recursion_limit' => 10 })
      expect(hash[:metadata]).to eq({ 'version' => '1.0' })
    end
  end

  describe '#to_json' do
    it 'converts to JSON' do
      json = assistant.to_json
      expect(json).to be_a(String)

      parsed = JSON.parse(json)
      expect(parsed['assistant_id']).to eq('test-id')
    end
  end
end
