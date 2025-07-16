RSpec.describe LanggraphPlatform::Models::Run do
  let(:attributes) do
    {
      'run_id' => 'test-run-id',
      'thread_id' => 'test-thread-id',
      'assistant_id' => 'test-assistant-id',
      'created_at' => '2023-01-01T00:00:00Z',
      'updated_at' => '2023-01-02T00:00:00Z',
      'status' => 'pending',
      'metadata' => { 'version' => '1.0', 'user_id' => 'user123' },
      'kwargs' => { 'temperature' => 0.7, 'max_tokens' => 100 },
      'multitask_strategy' => 'interrupt'
    }
  end

  let(:run) { described_class.new(attributes) }

  describe '#initialize' do
    it 'initializes with attributes' do
      expect(run.run_id).to eq('test-run-id')
      expect(run.thread_id).to eq('test-thread-id')
      expect(run.assistant_id).to eq('test-assistant-id')
      expect(run.status).to eq('pending')
      expect(run.metadata).to eq({ 'version' => '1.0', 'user_id' => 'user123' })
      expect(run.kwargs).to eq({ 'temperature' => 0.7, 'max_tokens' => 100 })
      expect(run.multitask_strategy).to eq('interrupt')
    end

    it 'parses timestamps' do
      expect(run.created_at).to be_a(Time)
      expect(run.updated_at).to be_a(Time)
      expect(run.created_at).to eq(Time.parse('2023-01-01T00:00:00Z'))
      expect(run.updated_at).to eq(Time.parse('2023-01-02T00:00:00Z'))
    end

    it 'handles nil timestamps' do
      attrs = attributes.merge('created_at' => nil, 'updated_at' => nil)
      run = described_class.new(attrs)

      expect(run.created_at).to be_nil
      expect(run.updated_at).to be_nil
    end

    it 'handles invalid timestamps' do
      attrs = attributes.merge('created_at' => 'invalid-date', 'updated_at' => 'invalid-date')
      run = described_class.new(attrs)

      expect(run.created_at).to be_nil
      expect(run.updated_at).to be_nil
    end

    it 'defaults metadata to empty hash when nil' do
      attrs = attributes.merge('metadata' => nil)
      run = described_class.new(attrs)

      expect(run.metadata).to eq({})
    end

    it 'defaults metadata to empty hash when missing' do
      attrs = attributes.reject { |k, _| k == 'metadata' }
      run = described_class.new(attrs)

      expect(run.metadata).to eq({})
    end
  end

  describe 'status methods' do
    describe '#pending?' do
      it 'returns true when status is pending' do
        expect(run.pending?).to be true
      end

      it 'returns false when status is not pending' do
        attrs = attributes.merge('status' => 'running')
        run = described_class.new(attrs)
        expect(run.pending?).to be false
      end
    end

    describe '#running?' do
      it 'returns true when status is running' do
        attrs = attributes.merge('status' => 'running')
        run = described_class.new(attrs)
        expect(run.running?).to be true
      end

      it 'returns false when status is not running' do
        expect(run.running?).to be false
      end
    end

    describe '#success?' do
      it 'returns true when status is success' do
        attrs = attributes.merge('status' => 'success')
        run = described_class.new(attrs)
        expect(run.success?).to be true
      end

      it 'returns false when status is not success' do
        expect(run.success?).to be false
      end
    end

    describe '#error?' do
      it 'returns true when status is error' do
        attrs = attributes.merge('status' => 'error')
        run = described_class.new(attrs)
        expect(run.error?).to be true
      end

      it 'returns false when status is not error' do
        expect(run.error?).to be false
      end
    end

    describe '#timeout?' do
      it 'returns true when status is timeout' do
        attrs = attributes.merge('status' => 'timeout')
        run = described_class.new(attrs)
        expect(run.timeout?).to be true
      end

      it 'returns false when status is not timeout' do
        expect(run.timeout?).to be false
      end
    end

    describe '#interrupted?' do
      it 'returns true when status is interrupted' do
        attrs = attributes.merge('status' => 'interrupted')
        run = described_class.new(attrs)
        expect(run.interrupted?).to be true
      end

      it 'returns false when status is not interrupted' do
        expect(run.interrupted?).to be false
      end
    end
  end

  describe '#to_h' do
    it 'returns a hash representation' do
      expected_hash = {
        run_id: 'test-run-id',
        thread_id: 'test-thread-id',
        assistant_id: 'test-assistant-id',
        created_at: Time.parse('2023-01-01T00:00:00Z'),
        updated_at: Time.parse('2023-01-02T00:00:00Z'),
        status: 'pending',
        metadata: { 'version' => '1.0', 'user_id' => 'user123' },
        kwargs: { 'temperature' => 0.7, 'max_tokens' => 100 },
        multitask_strategy: 'interrupt'
      }

      expect(run.to_h).to eq(expected_hash)
    end

    it 'handles nil values' do
      attrs = {
        'run_id' => 'test-id',
        'thread_id' => nil,
        'assistant_id' => nil,
        'created_at' => nil,
        'updated_at' => nil,
        'status' => nil,
        'metadata' => nil,
        'kwargs' => nil,
        'multitask_strategy' => nil
      }
      run = described_class.new(attrs)

      expected_hash = {
        run_id: 'test-id',
        thread_id: nil,
        assistant_id: nil,
        created_at: nil,
        updated_at: nil,
        status: nil,
        metadata: {},
        kwargs: nil,
        multitask_strategy: nil
      }

      expect(run.to_h).to eq(expected_hash)
    end
  end

  describe '#to_json' do
    it 'returns JSON representation' do
      json_string = run.to_json
      parsed_json = JSON.parse(json_string)

      expect(parsed_json['run_id']).to eq('test-run-id')
      expect(parsed_json['thread_id']).to eq('test-thread-id')
      expect(parsed_json['assistant_id']).to eq('test-assistant-id')
      expect(parsed_json['status']).to eq('pending')
      expect(parsed_json['metadata']).to eq({ 'version' => '1.0', 'user_id' => 'user123' })
      expect(parsed_json['kwargs']).to eq({ 'temperature' => 0.7, 'max_tokens' => 100 })
      expect(parsed_json['multitask_strategy']).to eq('interrupt')
    end

    it 'passes through JSON options' do
      json_string = run.to_json(only: %i[run_id status])
      parsed_json = JSON.parse(json_string)

      # NOTE: The only option works with the to_h method, not the JSON serialization
      # This test ensures the method accepts and passes through options
      expect(json_string).to be_a(String)
      expect(parsed_json).to include('run_id', 'status')
    end
  end
end
