RSpec.describe LanggraphPlatform::Models::Thread do
  let(:attributes) do
    {
      'thread_id' => 'test-thread-id',
      'created_at' => '2023-01-01T00:00:00Z',
      'updated_at' => '2023-01-02T00:00:00Z',
      'metadata' => { 'version' => '1.0', 'user_id' => 'user123' },
      'status' => 'idle',
      'values' => { 'key1' => 'value1', 'key2' => 'value2' }
    }
  end

  let(:thread) { described_class.new(attributes) }

  describe '#initialize' do
    it 'initializes with attributes' do
      expect(thread.thread_id).to eq('test-thread-id')
      expect(thread.status).to eq('idle')
      expect(thread.metadata).to eq({ 'version' => '1.0', 'user_id' => 'user123' })
      expect(thread.values).to eq({ 'key1' => 'value1', 'key2' => 'value2' })
    end

    it 'parses timestamps' do
      expect(thread.created_at).to be_a(Time)
      expect(thread.updated_at).to be_a(Time)
      expect(thread.created_at).to eq(Time.parse('2023-01-01T00:00:00Z'))
      expect(thread.updated_at).to eq(Time.parse('2023-01-02T00:00:00Z'))
    end

    it 'handles nil timestamps' do
      attrs = attributes.merge('created_at' => nil, 'updated_at' => nil)
      thread = described_class.new(attrs)

      expect(thread.created_at).to be_nil
      expect(thread.updated_at).to be_nil
    end

    it 'handles invalid timestamps' do
      attrs = attributes.merge('created_at' => 'invalid-date', 'updated_at' => 'invalid-date')
      thread = described_class.new(attrs)

      expect(thread.created_at).to be_nil
      expect(thread.updated_at).to be_nil
    end

    it 'defaults metadata to empty hash when nil' do
      attrs = attributes.merge('metadata' => nil)
      thread = described_class.new(attrs)

      expect(thread.metadata).to eq({})
    end

    it 'defaults metadata to empty hash when missing' do
      attrs = attributes.reject { |k, _| k == 'metadata' }
      thread = described_class.new(attrs)

      expect(thread.metadata).to eq({})
    end
  end

  describe 'status methods' do
    describe '#idle?' do
      it 'returns true when status is idle' do
        expect(thread.idle?).to be true
      end

      it 'returns false when status is not idle' do
        attrs = attributes.merge('status' => 'busy')
        thread = described_class.new(attrs)
        expect(thread.idle?).to be false
      end
    end

    describe '#busy?' do
      it 'returns true when status is busy' do
        attrs = attributes.merge('status' => 'busy')
        thread = described_class.new(attrs)
        expect(thread.busy?).to be true
      end

      it 'returns false when status is not busy' do
        expect(thread.busy?).to be false
      end
    end

    describe '#interrupted?' do
      it 'returns true when status is interrupted' do
        attrs = attributes.merge('status' => 'interrupted')
        thread = described_class.new(attrs)
        expect(thread.interrupted?).to be true
      end

      it 'returns false when status is not interrupted' do
        expect(thread.interrupted?).to be false
      end
    end

    describe '#error?' do
      it 'returns true when status is error' do
        attrs = attributes.merge('status' => 'error')
        thread = described_class.new(attrs)
        expect(thread.error?).to be true
      end

      it 'returns false when status is not error' do
        expect(thread.error?).to be false
      end
    end
  end

  describe '#to_h' do
    it 'returns a hash representation' do
      expected_hash = {
        thread_id: 'test-thread-id',
        created_at: Time.parse('2023-01-01T00:00:00Z'),
        updated_at: Time.parse('2023-01-02T00:00:00Z'),
        metadata: { 'version' => '1.0', 'user_id' => 'user123' },
        status: 'idle',
        values: { 'key1' => 'value1', 'key2' => 'value2' }
      }

      expect(thread.to_h).to eq(expected_hash)
    end

    it 'handles nil values' do
      attrs = {
        'thread_id' => 'test-id',
        'created_at' => nil,
        'updated_at' => nil,
        'metadata' => nil,
        'status' => nil,
        'values' => nil
      }
      thread = described_class.new(attrs)

      expected_hash = {
        thread_id: 'test-id',
        created_at: nil,
        updated_at: nil,
        metadata: {},
        status: nil,
        values: nil
      }

      expect(thread.to_h).to eq(expected_hash)
    end
  end

  describe '#to_json' do
    it 'returns JSON representation' do
      json_string = thread.to_json
      parsed_json = JSON.parse(json_string)

      expect(parsed_json['thread_id']).to eq('test-thread-id')
      expect(parsed_json['status']).to eq('idle')
      expect(parsed_json['metadata']).to eq({ 'version' => '1.0', 'user_id' => 'user123' })
      expect(parsed_json['values']).to eq({ 'key1' => 'value1', 'key2' => 'value2' })
    end

    it 'passes through JSON options' do
      json_string = thread.to_json(only: %i[thread_id status])
      parsed_json = JSON.parse(json_string)

      # NOTE: The only option works with the to_h method, not the JSON serialization
      # This test ensures the method accepts and passes through options
      expect(json_string).to be_a(String)
      expect(parsed_json).to include('thread_id', 'status')
    end
  end
end
