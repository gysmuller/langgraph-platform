module LanggraphPlatform
  module Resources
    class Assistants < BaseResource
      def create(**params)
        params[:config] ||= {}
        params[:metadata] ||= {}
        body = compact_params(params)
        response = @client.post('/assistants', body)
        Models::Assistant.new(response)
      end

      def find(assistant_id)
        response = @client.get("/assistants/#{assistant_id}")
        Models::Assistant.new(response)
      end

      def update(assistant_id, **params)
        body = compact_params(params)
        response = @client.patch("/assistants/#{assistant_id}", body)
        Models::Assistant.new(response)
      end

      def delete(assistant_id) # rubocop:disable Naming/PredicateMethod
        @client.delete("/assistants/#{assistant_id}")
        true
      end

      def search(**params)
        params[:metadata] ||= {}
        params[:limit] ||= 10
        params[:offset] ||= 0
        body = compact_params(params)
        response = @client.post('/assistants/search', body)
        response.map { |assistant_data| Models::Assistant.new(assistant_data) }
      end

      def graph(assistant_id, **params)
        params[:xray] ||= false
        query_params = compact_params(params)
        @client.get("/assistants/#{assistant_id}/graph", query_params)
      end

      def subgraphs(assistant_id, **params)
        params[:recurse] ||= false
        query_params = compact_params(params)
        @client.get("/assistants/#{assistant_id}/subgraphs", query_params)
      end

      def schemas(assistant_id)
        @client.get("/assistants/#{assistant_id}/schemas")
      end

      def versions(assistant_id)
        response = @client.post("/assistants/#{assistant_id}/versions")
        response.map { |assistant_data| Models::Assistant.new(assistant_data) }
      end

      def set_latest_version(assistant_id, **params)
        body = compact_params(params)
        response = @client.post("/assistants/#{assistant_id}/latest", body)
        Models::Assistant.new(response)
      end
    end
  end
end
