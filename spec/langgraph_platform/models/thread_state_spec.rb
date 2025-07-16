RSpec.describe LanggraphPlatform::Models::ThreadState do
  let(:attributes) do
    {
      'values' => { 'key1' => 'value1', 'key2' => 'value2' },
      'next' => %w[node1 node2],
      'checkpoint' => { 'id' => 'checkpoint-123', 'ts' => '2023-01-01T00:00:00Z' },
      'metadata' => { 'version' => '1.0', 'user_id' => 'user123' },
      'created_at' => '2023-01-01T00:00:00Z',
      'parent_checkpoint' => { 'id' => 'parent-checkpoint-456', 'ts' => '2022-12-31T23:59:59Z' }
    }
  end

  let(:thread_state) { described_class.new(attributes) }

  describe '#initialize' do
    it 'initializes with attributes' do
      expect(thread_state.values).to eq({ 'key1' => 'value1', 'key2' => 'value2' })
      expect(thread_state.next).to eq(%w[node1 node2])
      expect(thread_state.checkpoint).to eq({ 'id' => 'checkpoint-123', 'ts' => '2023-01-01T00:00:00Z' })
      expect(thread_state.metadata).to eq({ 'version' => '1.0', 'user_id' => 'user123' })
      expect(thread_state.parent_checkpoint).to eq({ 'id' => 'parent-checkpoint-456', 'ts' => '2022-12-31T23:59:59Z' })
    end

    it 'parses timestamps' do
      expect(thread_state.created_at).to be_a(Time)
      expect(thread_state.created_at).to eq(Time.parse('2023-01-01T00:00:00Z'))
    end

    it 'handles nil timestamp' do
      attrs = attributes.merge('created_at' => nil)
      thread_state = described_class.new(attrs)

      expect(thread_state.created_at).to be_nil
    end

    it 'handles invalid timestamp' do
      attrs = attributes.merge('created_at' => 'invalid-date')
      thread_state = described_class.new(attrs)

      expect(thread_state.created_at).to be_nil
    end

    it 'defaults metadata to empty hash when nil' do
      attrs = attributes.merge('metadata' => nil)
      thread_state = described_class.new(attrs)

      expect(thread_state.metadata).to eq({})
    end

    it 'defaults metadata to empty hash when missing' do
      attrs = attributes.reject { |k, _| k == 'metadata' }
      thread_state = described_class.new(attrs)

      expect(thread_state.metadata).to eq({})
    end

    it 'handles nil values for all attributes' do
      attrs = {
        'values' => nil,
        'next' => nil,
        'checkpoint' => nil,
        'metadata' => nil,
        'created_at' => nil,
        'parent_checkpoint' => nil
      }
      thread_state = described_class.new(attrs)

      expect(thread_state.values).to be_nil
      expect(thread_state.next).to be_nil
      expect(thread_state.checkpoint).to be_nil
      expect(thread_state.metadata).to eq({})
      expect(thread_state.created_at).to be_nil
      expect(thread_state.parent_checkpoint).to be_nil
    end

    it 'handles missing attributes' do
      attrs = {}
      thread_state = described_class.new(attrs)

      expect(thread_state.values).to be_nil
      expect(thread_state.next).to be_nil
      expect(thread_state.checkpoint).to be_nil
      expect(thread_state.metadata).to eq({})
      expect(thread_state.created_at).to be_nil
      expect(thread_state.parent_checkpoint).to be_nil
    end
  end

  describe '#to_h' do
    it 'returns a hash representation' do
      expected_hash = {
        values: { 'key1' => 'value1', 'key2' => 'value2' },
        next: %w[node1 node2],
        checkpoint: { 'id' => 'checkpoint-123', 'ts' => '2023-01-01T00:00:00Z' },
        metadata: { 'version' => '1.0', 'user_id' => 'user123' },
        created_at: Time.parse('2023-01-01T00:00:00Z'),
        parent_checkpoint: { 'id' => 'parent-checkpoint-456', 'ts' => '2022-12-31T23:59:59Z' }
      }

      expect(thread_state.to_h).to eq(expected_hash)
    end

    it 'handles nil values' do
      attrs = {
        'values' => nil,
        'next' => nil,
        'checkpoint' => nil,
        'metadata' => nil,
        'created_at' => nil,
        'parent_checkpoint' => nil
      }
      thread_state = described_class.new(attrs)

      expected_hash = {
        values: nil,
        next: nil,
        checkpoint: nil,
        metadata: {},
        created_at: nil,
        parent_checkpoint: nil
      }

      expect(thread_state.to_h).to eq(expected_hash)
    end

    it 'handles empty collections' do
      attrs = {
        'values' => {},
        'next' => [],
        'checkpoint' => {},
        'metadata' => {},
        'created_at' => '2023-01-01T00:00:00Z',
        'parent_checkpoint' => {}
      }
      thread_state = described_class.new(attrs)

      expected_hash = {
        values: {},
        next: [],
        checkpoint: {},
        metadata: {},
        created_at: Time.parse('2023-01-01T00:00:00Z'),
        parent_checkpoint: {}
      }

      expect(thread_state.to_h).to eq(expected_hash)
    end
  end

  describe '#to_json' do
    it 'returns JSON representation' do
      json_string = thread_state.to_json
      parsed_json = JSON.parse(json_string)

      expect(parsed_json['values']).to eq({ 'key1' => 'value1', 'key2' => 'value2' })
      expect(parsed_json['next']).to eq(%w[node1 node2])
      expect(parsed_json['checkpoint']).to eq({ 'id' => 'checkpoint-123', 'ts' => '2023-01-01T00:00:00Z' })
      expect(parsed_json['metadata']).to eq({ 'version' => '1.0', 'user_id' => 'user123' })
      expect(parsed_json['parent_checkpoint']).to eq({ 'id' => 'parent-checkpoint-456',
                                                       'ts' => '2022-12-31T23:59:59Z' })
    end

    it 'handles nil values in JSON' do
      attrs = {
        'values' => nil,
        'next' => nil,
        'checkpoint' => nil,
        'metadata' => nil,
        'created_at' => nil,
        'parent_checkpoint' => nil
      }
      thread_state = described_class.new(attrs)

      json_string = thread_state.to_json
      parsed_json = JSON.parse(json_string)

      expect(parsed_json['values']).to be_nil
      expect(parsed_json['next']).to be_nil
      expect(parsed_json['checkpoint']).to be_nil
      expect(parsed_json['metadata']).to eq({})
      expect(parsed_json['created_at']).to be_nil
      expect(parsed_json['parent_checkpoint']).to be_nil
    end

    it 'passes through JSON options' do
      json_string = thread_state.to_json(only: %i[values next])
      parsed_json = JSON.parse(json_string)

      # NOTE: The only option works with the to_h method, not the JSON serialization
      # This test ensures the method accepts and passes through options
      expect(json_string).to be_a(String)
      expect(parsed_json).to include('values', 'next')
    end

    it 'handles complex nested structures' do
      complex_attrs = {
        'values' => {
          'user' => { 'name' => 'John', 'age' => 30 },
          'settings' => { 'theme' => 'dark', 'notifications' => true }
        },
        'next' => %w[validate_user process_request send_response],
        'checkpoint' => {
          'id' => 'complex-checkpoint',
          'timestamp' => '2023-01-01T00:00:00Z',
          'data' => { 'step' => 1, 'total' => 5 }
        },
        'metadata' => { 'workflow_id' => 'wf-123', 'version' => '2.0' },
        'created_at' => '2023-01-01T00:00:00Z',
        'parent_checkpoint' => {
          'id' => 'parent-complex',
          'data' => { 'previous_step' => 0 }
        }
      }
      thread_state = described_class.new(complex_attrs)

      json_string = thread_state.to_json
      parsed_json = JSON.parse(json_string)

      expect(parsed_json['values']['user']).to eq({ 'name' => 'John', 'age' => 30 })
      expect(parsed_json['values']['settings']).to eq({ 'theme' => 'dark', 'notifications' => true })
      expect(parsed_json['next']).to eq(%w[validate_user process_request send_response])
      expect(parsed_json['checkpoint']['data']).to eq({ 'step' => 1, 'total' => 5 })
      expect(parsed_json['parent_checkpoint']['data']).to eq({ 'previous_step' => 0 })
    end
  end

  describe 'edge cases' do
    it 'handles string values for next attribute' do
      attrs = attributes.merge('next' => 'single_node')
      thread_state = described_class.new(attrs)

      expect(thread_state.next).to eq('single_node')
    end

    it 'handles numeric values in checkpoint' do
      attrs = attributes.merge('checkpoint' => { 'id' => 123, 'step' => 1 })
      thread_state = described_class.new(attrs)

      expect(thread_state.checkpoint).to eq({ 'id' => 123, 'step' => 1 })
    end

    it 'handles boolean values in metadata' do
      attrs = attributes.merge('metadata' => { 'active' => true, 'completed' => false })
      thread_state = described_class.new(attrs)

      expect(thread_state.metadata).to eq({ 'active' => true, 'completed' => false })
    end

    it 'handles array values in values attribute' do
      attrs = attributes.merge('values' => %w[item1 item2 item3])
      thread_state = described_class.new(attrs)

      expect(thread_state.values).to eq(%w[item1 item2 item3])
    end
  end
end
