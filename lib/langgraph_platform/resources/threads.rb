module LanggraphPlatform
  module Resources
    class Threads < BaseResource
      def create(**params)
        params[:metadata] ||= {}
        body = compact_params(params)
        response = @client.post('/threads', body)
        Models::Thread.new(response)
      end

      def find(thread_id)
        response = @client.get("/threads/#{thread_id}")
        Models::Thread.new(response)
      end

      def update(thread_id, **params)
        params[:metadata] ||= {}
        body = compact_params(params)
        response = @client.patch("/threads/#{thread_id}", body)
        Models::Thread.new(response)
      end

      def delete(thread_id) # rubocop:disable Naming/PredicateMethod
        @client.delete("/threads/#{thread_id}")
        true
      end

      def search(**params)
        params[:metadata] ||= {}
        params[:values] ||= {}
        params[:limit] ||= 10
        params[:offset] ||= 0
        body = compact_params(params)
        response = @client.post('/threads/search', body)
        response.map { |thread_data| Models::Thread.new(thread_data) }
      end

      def state(thread_id, **params)
        params[:subgraphs] ||= false
        query_params = compact_params(params)
        response = @client.get("/threads/#{thread_id}/state", query_params)
        Models::ThreadState.new(response)
      end

      def update_state(thread_id, **params)
        body = compact_params(params)
        @client.post("/threads/#{thread_id}/state", body)
      end

      def history(thread_id, **params)
        params[:limit] ||= 10
        query_params = compact_params(params)
        response = @client.get("/threads/#{thread_id}/history", query_params)
        response.map { |state_data| Models::ThreadState.new(state_data) }
      end

      def copy(thread_id)
        response = @client.post("/threads/#{thread_id}/copy")
        Models::Thread.new(response)
      end
    end
  end
end
