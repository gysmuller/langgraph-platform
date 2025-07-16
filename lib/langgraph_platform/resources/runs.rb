module LanggraphPlatform
  module Resources
    class Runs < BaseResource
      def create(thread_id, **params)
        body = compact_params(params)
        response = @client.post("/threads/#{thread_id}/runs", body)
        Models::Run.new(response)
      end

      def stream(thread_id, **params, &block)
        params[:stream_mode] = Array(params[:stream_mode] || ['values'])
        body = compact_params(params)
        @client.stream("/threads/#{thread_id}/runs/stream", body, &block)
      end

      def wait(thread_id, **params)
        body = compact_params(params)
        @client.post("/threads/#{thread_id}/runs/wait", body)
      end

      def find(thread_id, run_id)
        response = @client.get("/threads/#{thread_id}/runs/#{run_id}")
        Models::Run.new(response)
      end

      def list(thread_id, **params)
        params[:limit] ||= 10
        params[:offset] ||= 0
        query_params = compact_params(params)
        response = @client.get("/threads/#{thread_id}/runs", query_params)
        response.map { |run_data| Models::Run.new(run_data) }
      end

      def cancel(thread_id, run_id, **params)
        params[:wait] ||= false
        params[:action] ||= 'interrupt'
        body = compact_params(params)
        @client.post("/threads/#{thread_id}/runs/#{run_id}/cancel", body)
      end

      def join(thread_id, run_id, **params)
        params[:cancel_on_disconnect] ||= false
        query_params = compact_params(params)
        @client.get("/threads/#{thread_id}/runs/#{run_id}/join", query_params)
      end

      def join_stream(thread_id, run_id, &block)
        @client.stream("/threads/#{thread_id}/runs/#{run_id}/stream", &block)
      end

      def delete(thread_id, run_id) # rubocop:disable Naming/PredicateMethod
        @client.delete("/threads/#{thread_id}/runs/#{run_id}")
        true
      end

      # Stateless runs
      def create_stateless(**params)
        body = compact_params(params)
        @client.post('/runs', body)
      end

      def stream_stateless(**params, &block)
        params[:stream_mode] = Array(params[:stream_mode] || ['values'])
        body = compact_params(params)
        @client.stream('/runs/stream', body, &block)
      end

      def wait_stateless(**params)
        body = compact_params(params)
        @client.post('/runs/wait', body)
      end

      def create_batch(runs)
        @client.post('/runs/batch', runs)
      end

      def cancel_multiple(**params)
        params[:action] ||= 'interrupt'
        body = compact_params(params)
        @client.post('/runs/cancel', body)
      end
    end
  end
end
