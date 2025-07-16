RSpec.describe LanggraphPlatform::Resources::Runs do
  let(:client) { instance_double(LanggraphPlatform::BaseClient) }
  let(:runs) { described_class.new(client) }
  let(:thread_id) { 'test-thread-id' }
  let(:run_id) { 'test-run-id' }
  let(:assistant_id) { 'test-assistant-id' }

  describe '#create' do
    it 'creates a run with minimal parameters' do
      response = {
        'run_id' => 'generated-run-id',
        'thread_id' => thread_id,
        'assistant_id' => assistant_id,
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'status' => 'pending',
        'metadata' => {},
        'kwargs' => nil,
        'multitask_strategy' => nil
      }

      expect(client).to receive(:post).with("/threads/#{thread_id}/runs", {
                                              assistant_id: assistant_id
                                            }).and_return(response)

      run = runs.create(thread_id, assistant_id: assistant_id)
      expect(run).to be_a(LanggraphPlatform::Models::Run)
      expect(run.run_id).to eq('generated-run-id')
      expect(run.thread_id).to eq(thread_id)
      expect(run.assistant_id).to eq(assistant_id)
    end

    it 'creates a run with all parameters' do
      response = {
        'run_id' => 'generated-run-id',
        'thread_id' => thread_id,
        'assistant_id' => assistant_id,
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'status' => 'pending',
        'metadata' => { 'custom' => 'value' },
        'kwargs' => { 'temperature' => 0.7 },
        'multitask_strategy' => 'interrupt'
      }

      expect(client).to receive(:post).with("/threads/#{thread_id}/runs", {
                                              assistant_id: assistant_id,
                                              input: { 'message' => 'test' },
                                              webhook: 'https://example.com/webhook',
                                              metadata: { 'custom' => 'value' }
                                            }).and_return(response)

      run = runs.create(
        thread_id,
        assistant_id: assistant_id,
        input: { 'message' => 'test' },
        webhook: 'https://example.com/webhook',
        metadata: { 'custom' => 'value' }
      )
      expect(run).to be_a(LanggraphPlatform::Models::Run)
    end

    it 'filters out nil parameters' do
      response = {
        'run_id' => 'generated-run-id',
        'thread_id' => thread_id,
        'assistant_id' => assistant_id,
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'status' => 'pending',
        'metadata' => {},
        'kwargs' => nil,
        'multitask_strategy' => nil
      }

      expect(client).to receive(:post).with("/threads/#{thread_id}/runs", {
                                              assistant_id: assistant_id
                                            }).and_return(response)

      runs.create(thread_id, assistant_id: assistant_id, input: nil, webhook: nil)
    end
  end

  describe '#stream' do
    it 'streams a run with block' do
      expect(client).to receive(:stream).with("/threads/#{thread_id}/runs/stream", {
                                                assistant_id: assistant_id,
                                                input: { 'message' => 'test' },
                                                stream_mode: ['values']
                                              })

      runs.stream(thread_id, assistant_id: assistant_id, input: { 'message' => 'test' }) do |chunk|
        # Block handling
      end
    end

    it 'filters out nil parameters' do
      expect(client).to receive(:stream).with("/threads/#{thread_id}/runs/stream", {
                                                assistant_id: assistant_id,
                                                stream_mode: ['values']
                                              })

      runs.stream(thread_id, assistant_id: assistant_id, input: nil, webhook: nil) do |chunk|
        # Block handling
      end
    end
  end

  describe '#wait' do
    it 'waits for a run to complete' do
      response = { 'status' => 'success', 'result' => 'completed' }

      expect(client).to receive(:post).with("/threads/#{thread_id}/runs/wait", {
                                              assistant_id: assistant_id,
                                              input: { 'message' => 'test' }
                                            }).and_return(response)

      result = runs.wait(thread_id, assistant_id: assistant_id, input: { 'message' => 'test' })
      expect(result).to eq(response)
    end

    it 'filters out nil parameters' do
      response = { 'status' => 'success' }

      expect(client).to receive(:post).with("/threads/#{thread_id}/runs/wait", {
                                              assistant_id: assistant_id
                                            }).and_return(response)

      runs.wait(thread_id, assistant_id: assistant_id, input: nil, webhook: nil)
    end
  end

  describe '#find' do
    it 'finds a run by ID' do
      response = {
        'run_id' => run_id,
        'thread_id' => thread_id,
        'assistant_id' => assistant_id,
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'status' => 'success',
        'metadata' => { 'version' => '1.0' },
        'kwargs' => { 'temperature' => 0.7 },
        'multitask_strategy' => 'interrupt'
      }

      expect(client).to receive(:get).with("/threads/#{thread_id}/runs/#{run_id}").and_return(response)

      run = runs.find(thread_id, run_id)
      expect(run).to be_a(LanggraphPlatform::Models::Run)
      expect(run.run_id).to eq(run_id)
      expect(run.thread_id).to eq(thread_id)
      expect(run.status).to eq('success')
    end
  end

  describe '#list' do
    it 'lists runs with default parameters' do
      response = [
        {
          'run_id' => 'run-1',
          'thread_id' => thread_id,
          'assistant_id' => assistant_id,
          'created_at' => '2023-01-01T00:00:00Z',
          'updated_at' => '2023-01-01T00:00:00Z',
          'status' => 'pending',
          'metadata' => {},
          'kwargs' => nil,
          'multitask_strategy' => nil
        },
        {
          'run_id' => 'run-2',
          'thread_id' => thread_id,
          'assistant_id' => assistant_id,
          'created_at' => '2023-01-02T00:00:00Z',
          'updated_at' => '2023-01-02T00:00:00Z',
          'status' => 'success',
          'metadata' => {},
          'kwargs' => nil,
          'multitask_strategy' => nil
        }
      ]

      expect(client).to receive(:get).with("/threads/#{thread_id}/runs", {
                                             limit: 10,
                                             offset: 0
                                           }).and_return(response)

      runs_result = runs.list(thread_id)
      expect(runs_result).to be_an(Array)
      expect(runs_result.length).to eq(2)
      expect(runs_result.first).to be_a(LanggraphPlatform::Models::Run)
      expect(runs_result.first.run_id).to eq('run-1')
      expect(runs_result.last.run_id).to eq('run-2')
    end

    it 'lists runs with custom parameters' do
      response = [
        {
          'run_id' => 'run-1',
          'thread_id' => thread_id,
          'assistant_id' => assistant_id,
          'created_at' => '2023-01-01T00:00:00Z',
          'updated_at' => '2023-01-01T00:00:00Z',
          'status' => 'pending',
          'metadata' => {},
          'kwargs' => nil,
          'multitask_strategy' => nil
        }
      ]

      expect(client).to receive(:get).with("/threads/#{thread_id}/runs", {
                                             limit: 5,
                                             offset: 10,
                                             status: 'pending'
                                           }).and_return(response)

      runs_result = runs.list(thread_id, limit: 5, offset: 10, status: 'pending')
      expect(runs_result).to be_an(Array)
      expect(runs_result.length).to eq(1)
      expect(runs_result.first.status).to eq('pending')
    end

    it 'filters out nil parameters' do
      response = []

      expect(client).to receive(:get).with("/threads/#{thread_id}/runs", {
                                             limit: 10,
                                             offset: 0
                                           }).and_return(response)

      runs.list(thread_id, status: nil)
    end
  end

  describe '#cancel' do
    it 'cancels a run with default parameters' do
      expect(client).to receive(:post).with("/threads/#{thread_id}/runs/#{run_id}/cancel", {
                                              wait: false,
                                              action: 'interrupt'
                                            })

      runs.cancel(thread_id, run_id)
    end

    it 'cancels a run with custom parameters' do
      expect(client).to receive(:post).with("/threads/#{thread_id}/runs/#{run_id}/cancel", {
                                              wait: true,
                                              action: 'terminate'
                                            })

      runs.cancel(thread_id, run_id, wait: true, action: 'terminate')
    end
  end

  describe '#join' do
    it 'joins a run with default parameters' do
      response = { 'status' => 'success', 'result' => 'completed' }

      expect(client).to receive(:get).with("/threads/#{thread_id}/runs/#{run_id}/join", {
                                             cancel_on_disconnect: false
                                           }).and_return(response)

      result = runs.join(thread_id, run_id)
      expect(result).to eq(response)
    end

    it 'joins a run with custom parameters' do
      response = { 'status' => 'success' }

      expect(client).to receive(:get).with("/threads/#{thread_id}/runs/#{run_id}/join", {
                                             cancel_on_disconnect: true
                                           }).and_return(response)

      runs.join(thread_id, run_id, cancel_on_disconnect: true)
    end
  end

  describe '#join_stream' do
    it 'joins a run stream with block' do
      expect(client).to receive(:stream).with("/threads/#{thread_id}/runs/#{run_id}/stream")

      runs.join_stream(thread_id, run_id) do |chunk|
        # Block handling
      end
    end
  end

  describe '#delete' do
    it 'deletes a run' do
      expect(client).to receive(:delete).with("/threads/#{thread_id}/runs/#{run_id}")

      result = runs.delete(thread_id, run_id)
      expect(result).to be true
    end
  end

  describe 'stateless runs' do
    describe '#create_stateless' do
      it 'creates a stateless run with minimal parameters' do
        response = { 'run_id' => 'stateless-run-id', 'status' => 'pending' }

        expect(client).to receive(:post).with('/runs', {
                                                assistant_id: assistant_id
                                              }).and_return(response)

        result = runs.create_stateless(assistant_id: assistant_id)
        expect(result).to eq(response)
      end

      it 'creates a stateless run with all parameters' do
        response = { 'run_id' => 'stateless-run-id', 'status' => 'pending' }

        expect(client).to receive(:post).with('/runs', {
                                                assistant_id: assistant_id,
                                                input: { 'message' => 'test' },
                                                webhook: 'https://example.com/webhook',
                                                metadata: { 'custom' => 'value' }
                                              }).and_return(response)

        runs.create_stateless(
          assistant_id: assistant_id,
          input: { 'message' => 'test' },
          webhook: 'https://example.com/webhook',
          metadata: { 'custom' => 'value' }
        )
      end

      it 'filters out nil parameters' do
        response = { 'run_id' => 'stateless-run-id' }

        expect(client).to receive(:post).with('/runs', {
                                                assistant_id: assistant_id
                                              }).and_return(response)

        runs.create_stateless(assistant_id: assistant_id, input: nil, webhook: nil)
      end
    end

    describe '#stream_stateless' do
      it 'streams a stateless run with block' do
        expect(client).to receive(:stream).with('/runs/stream', {
                                                  assistant_id: assistant_id,
                                                  input: { 'message' => 'test' },
                                                  stream_mode: ['values']
                                                })

        runs.stream_stateless(assistant_id: assistant_id, input: { 'message' => 'test' }) do |chunk|
          # Block handling
        end
      end

      it 'filters out nil parameters' do
        expect(client).to receive(:stream).with('/runs/stream', {
                                                  assistant_id: assistant_id,
                                                  stream_mode: ['values']
                                                })

        runs.stream_stateless(assistant_id: assistant_id, input: nil, webhook: nil) do |chunk|
          # Block handling
        end
      end
    end

    describe '#wait_stateless' do
      it 'waits for a stateless run to complete' do
        response = { 'status' => 'success', 'result' => 'completed' }

        expect(client).to receive(:post).with('/runs/wait', {
                                                assistant_id: assistant_id,
                                                input: { 'message' => 'test' }
                                              }).and_return(response)

        result = runs.wait_stateless(assistant_id: assistant_id, input: { 'message' => 'test' })
        expect(result).to eq(response)
      end

      it 'filters out nil parameters' do
        response = { 'status' => 'success' }

        expect(client).to receive(:post).with('/runs/wait', {
                                                assistant_id: assistant_id
                                              }).and_return(response)

        runs.wait_stateless(assistant_id: assistant_id, input: nil, webhook: nil)
      end
    end
  end

  describe '#create_batch' do
    it 'creates a batch of runs' do
      batch_runs = [
        { assistant_id: assistant_id, input: { 'message' => 'test1' } },
        { assistant_id: assistant_id, input: { 'message' => 'test2' } }
      ]
      response = { 'batch_id' => 'batch-123', 'status' => 'pending' }

      expect(client).to receive(:post).with('/runs/batch', batch_runs).and_return(response)

      result = runs.create_batch(batch_runs)
      expect(result).to eq(response)
    end
  end

  describe '#cancel_multiple' do
    it 'cancels multiple runs with default parameters' do
      response = { 'cancelled_count' => 5 }

      expect(client).to receive(:post).with('/runs/cancel', {
                                              action: 'interrupt'
                                            }).and_return(response)

      result = runs.cancel_multiple
      expect(result).to eq(response)
    end

    it 'cancels multiple runs with custom parameters' do
      response = { 'cancelled_count' => 3 }

      expect(client).to receive(:post).with('/runs/cancel', {
                                              status: 'pending',
                                              thread_id: thread_id,
                                              run_ids: %w[run-1 run-2],
                                              action: 'terminate'
                                            }).and_return(response)

      result = runs.cancel_multiple(
        status: 'pending',
        thread_id: thread_id,
        run_ids: %w[run-1 run-2],
        action: 'terminate'
      )
      expect(result).to eq(response)
    end

    it 'filters out nil parameters' do
      response = { 'cancelled_count' => 0 }

      expect(client).to receive(:post).with('/runs/cancel', {
                                              action: 'interrupt'
                                            }).and_return(response)

      runs.cancel_multiple(status: nil, thread_id: nil, run_ids: nil)
    end
  end
end
