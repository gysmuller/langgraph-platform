RSpec.describe LanggraphPlatform::Resources::Threads do
  let(:client) { instance_double(LanggraphPlatform::BaseClient) }
  let(:threads) { described_class.new(client) }

  describe '#create' do
    it 'creates a thread with default parameters' do
      response = {
        'thread_id' => 'generated-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => {},
        'status' => 'idle',
        'values' => nil
      }

      expect(client).to receive(:post).with('/threads', { metadata: {} }).and_return(response)

      thread = threads.create
      expect(thread).to be_a(LanggraphPlatform::Models::Thread)
      expect(thread.thread_id).to eq('generated-thread-id')
      expect(thread.status).to eq('idle')
    end

    it 'creates a thread with custom thread_id and metadata' do
      response = {
        'thread_id' => 'custom-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => { 'user_id' => 'user123' },
        'status' => 'idle',
        'values' => nil
      }

      expect(client).to receive(:post).with('/threads', {
                                              thread_id: 'custom-thread-id',
                                              metadata: { 'user_id' => 'user123' }
                                            }).and_return(response)

      thread = threads.create(thread_id: 'custom-thread-id', metadata: { 'user_id' => 'user123' })
      expect(thread).to be_a(LanggraphPlatform::Models::Thread)
      expect(thread.thread_id).to eq('custom-thread-id')
      expect(thread.metadata).to eq({ 'user_id' => 'user123' })
    end

    it 'creates a thread with additional options' do
      response = {
        'thread_id' => 'test-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => {},
        'status' => 'idle',
        'values' => nil
      }

      expect(client).to receive(:post).with('/threads', {
                                              metadata: {},
                                              custom_option: 'value'
                                            }).and_return(response)

      thread = threads.create(custom_option: 'value')
      expect(thread).to be_a(LanggraphPlatform::Models::Thread)
    end
  end

  describe '#find' do
    it 'finds a thread by ID' do
      response = {
        'thread_id' => 'test-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => { 'version' => '1.0' },
        'status' => 'idle',
        'values' => { 'key' => 'value' }
      }

      expect(client).to receive(:get).with('/threads/test-thread-id').and_return(response)

      thread = threads.find('test-thread-id')
      expect(thread).to be_a(LanggraphPlatform::Models::Thread)
      expect(thread.thread_id).to eq('test-thread-id')
      expect(thread.metadata).to eq({ 'version' => '1.0' })
    end
  end

  describe '#update' do
    it 'updates a thread with new metadata' do
      response = {
        'thread_id' => 'test-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-02T00:00:00Z',
        'metadata' => { 'updated' => true },
        'status' => 'idle',
        'values' => nil
      }

      expect(client).to receive(:patch).with('/threads/test-thread-id', {
                                               metadata: { 'updated' => true }
                                             }).and_return(response)

      thread = threads.update('test-thread-id', metadata: { 'updated' => true })
      expect(thread).to be_a(LanggraphPlatform::Models::Thread)
      expect(thread.metadata).to eq({ 'updated' => true })
    end

    it 'updates a thread with empty metadata' do
      response = {
        'thread_id' => 'test-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-02T00:00:00Z',
        'metadata' => {},
        'status' => 'idle',
        'values' => nil
      }

      expect(client).to receive(:patch).with('/threads/test-thread-id', {
                                               metadata: {}
                                             }).and_return(response)

      thread = threads.update('test-thread-id')
      expect(thread).to be_a(LanggraphPlatform::Models::Thread)
    end
  end

  describe '#delete' do
    it 'deletes a thread' do
      expect(client).to receive(:delete).with('/threads/test-thread-id')

      result = threads.delete('test-thread-id')
      expect(result).to be true
    end
  end

  describe '#search' do
    it 'searches threads with default parameters' do
      response = [
        {
          'thread_id' => 'thread-1',
          'created_at' => '2023-01-01T00:00:00Z',
          'updated_at' => '2023-01-01T00:00:00Z',
          'metadata' => {},
          'status' => 'idle',
          'values' => nil
        },
        {
          'thread_id' => 'thread-2',
          'created_at' => '2023-01-02T00:00:00Z',
          'updated_at' => '2023-01-02T00:00:00Z',
          'metadata' => {},
          'status' => 'busy',
          'values' => nil
        }
      ]

      expect(client).to receive(:post).with('/threads/search', {
                                              metadata: {},
                                              values: {},
                                              limit: 10,
                                              offset: 0
                                            }).and_return(response)

      threads_result = threads.search
      expect(threads_result).to be_an(Array)
      expect(threads_result.length).to eq(2)
      expect(threads_result.first).to be_a(LanggraphPlatform::Models::Thread)
      expect(threads_result.first.thread_id).to eq('thread-1')
      expect(threads_result.last.thread_id).to eq('thread-2')
    end

    it 'searches threads with custom parameters' do
      response = [
        {
          'thread_id' => 'thread-1',
          'created_at' => '2023-01-01T00:00:00Z',
          'updated_at' => '2023-01-01T00:00:00Z',
          'metadata' => { 'user_id' => 'user123' },
          'status' => 'idle',
          'values' => { 'key' => 'value' }
        }
      ]

      expect(client).to receive(:post).with('/threads/search', {
                                              metadata: { 'user_id' => 'user123' },
                                              values: { 'key' => 'value' },
                                              status: 'idle',
                                              limit: 5,
                                              offset: 10
                                            }).and_return(response)

      threads_result = threads.search(
        metadata: { 'user_id' => 'user123' },
        values: { 'key' => 'value' },
        status: 'idle',
        limit: 5,
        offset: 10
      )
      expect(threads_result).to be_an(Array)
      expect(threads_result.length).to eq(1)
      expect(threads_result.first.metadata).to eq({ 'user_id' => 'user123' })
    end

    it 'filters out nil parameters' do
      response = []

      expect(client).to receive(:post).with('/threads/search', {
                                              metadata: {},
                                              values: {},
                                              limit: 10,
                                              offset: 0
                                            }).and_return(response)

      threads.search(status: nil)
    end
  end

  describe '#state' do
    it 'gets thread state with default parameters' do
      response = {
        'values' => { 'key' => 'value' },
        'next' => ['node1'],
        'checkpoint' => { 'id' => 'checkpoint-1' },
        'metadata' => {},
        'created_at' => '2023-01-01T00:00:00Z',
        'parent_checkpoint' => nil
      }

      expect(client).to receive(:get).with('/threads/test-thread-id/state', {
                                             subgraphs: false
                                           }).and_return(response)

      state = threads.state('test-thread-id')
      expect(state).to be_a(LanggraphPlatform::Models::ThreadState)
      expect(state.values).to eq({ 'key' => 'value' })
      expect(state.next).to eq(['node1'])
    end

    it 'gets thread state with subgraphs enabled' do
      response = {
        'values' => { 'key' => 'value' },
        'next' => ['node1'],
        'checkpoint' => { 'id' => 'checkpoint-1' },
        'metadata' => {},
        'created_at' => '2023-01-01T00:00:00Z',
        'parent_checkpoint' => nil
      }

      expect(client).to receive(:get).with('/threads/test-thread-id/state', {
                                             subgraphs: true
                                           }).and_return(response)

      state = threads.state('test-thread-id', subgraphs: true)
      expect(state).to be_a(LanggraphPlatform::Models::ThreadState)
    end
  end

  describe '#update_state' do
    it 'updates thread state with default parameters' do
      expect(client).to receive(:post).with('/threads/test-thread-id/state', {})

      threads.update_state('test-thread-id')
    end

    it 'updates thread state with custom parameters' do
      expect(client).to receive(:post).with('/threads/test-thread-id/state', {
                                              values: { 'key' => 'new_value' },
                                              checkpoint: { 'id' => 'checkpoint-2' },
                                              as_node: 'node1'
                                            })

      threads.update_state(
        'test-thread-id',
        values: { 'key' => 'new_value' },
        checkpoint: { 'id' => 'checkpoint-2' },
        as_node: 'node1'
      )
    end

    it 'filters out nil parameters' do
      expect(client).to receive(:post).with('/threads/test-thread-id/state', {
                                              values: { 'key' => 'value' }
                                            })

      threads.update_state('test-thread-id', values: { 'key' => 'value' }, checkpoint: nil)
    end
  end

  describe '#history' do
    it 'gets thread history with default parameters' do
      response = [
        {
          'values' => { 'key' => 'value1' },
          'next' => ['node1'],
          'checkpoint' => { 'id' => 'checkpoint-1' },
          'metadata' => {},
          'created_at' => '2023-01-01T00:00:00Z',
          'parent_checkpoint' => nil
        },
        {
          'values' => { 'key' => 'value2' },
          'next' => ['node2'],
          'checkpoint' => { 'id' => 'checkpoint-2' },
          'metadata' => {},
          'created_at' => '2023-01-02T00:00:00Z',
          'parent_checkpoint' => { 'id' => 'checkpoint-1' }
        }
      ]

      expect(client).to receive(:get).with('/threads/test-thread-id/history', {
                                             limit: 10
                                           }).and_return(response)

      history = threads.history('test-thread-id')
      expect(history).to be_an(Array)
      expect(history.length).to eq(2)
      expect(history.first).to be_a(LanggraphPlatform::Models::ThreadState)
      expect(history.first.values).to eq({ 'key' => 'value1' })
      expect(history.last.values).to eq({ 'key' => 'value2' })
    end

    it 'gets thread history with custom parameters' do
      response = []

      expect(client).to receive(:get).with('/threads/test-thread-id/history', {
                                             limit: 5,
                                             before: 'checkpoint-1'
                                           }).and_return(response)

      history = threads.history('test-thread-id', limit: 5, before: 'checkpoint-1')
      expect(history).to be_an(Array)
      expect(history).to be_empty
    end

    it 'filters out nil parameters' do
      response = []

      expect(client).to receive(:get).with('/threads/test-thread-id/history', {
                                             limit: 10
                                           }).and_return(response)

      threads.history('test-thread-id', before: nil)
    end
  end

  describe '#copy' do
    it 'copies a thread' do
      response = {
        'thread_id' => 'new-thread-id',
        'created_at' => '2023-01-01T00:00:00Z',
        'updated_at' => '2023-01-01T00:00:00Z',
        'metadata' => { 'copied_from' => 'original-thread-id' },
        'status' => 'idle',
        'values' => { 'key' => 'value' }
      }

      expect(client).to receive(:post).with('/threads/original-thread-id/copy').and_return(response)

      copied_thread = threads.copy('original-thread-id')
      expect(copied_thread).to be_a(LanggraphPlatform::Models::Thread)
      expect(copied_thread.thread_id).to eq('new-thread-id')
      expect(copied_thread.metadata).to eq({ 'copied_from' => 'original-thread-id' })
    end
  end
end
