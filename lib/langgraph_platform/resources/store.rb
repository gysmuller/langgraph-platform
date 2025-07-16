module LanggraphPlatform
  module Resources
    class Store < BaseResource
      def get(namespace, key)
        response = @client.get("/store/#{namespace}/#{key}")
        Models::StoreItem.new(response)
      end

      def put(namespace, key, **params)
        body = compact_params(params)
        response = @client.put("/store/#{namespace}/#{key}", body)
        Models::StoreItem.new(response)
      end

      def delete(namespace, key) # rubocop:disable Naming/PredicateMethod
        @client.delete("/store/#{namespace}/#{key}")
        true
      end

      def list(namespace, **params)
        params[:limit] ||= 10
        params[:offset] ||= 0
        query_params = compact_params(params)
        response = @client.get("/store/#{namespace}", query_params)
        response.map { |item_data| Models::StoreItem.new(item_data) }
      end

      def search(**params)
        params[:limit] ||= 10
        params[:offset] ||= 0
        body = compact_params(params)
        response = @client.post('/store/search', body)
        response.map { |item_data| Models::StoreItem.new(item_data) }
      end

      def batch_get(**params)
        body = compact_params(params)
        response = @client.post('/store/batch', body)
        response.map { |item_data| Models::StoreItem.new(item_data) }
      end

      def batch_put(**params)
        body = compact_params(params)
        response = @client.put('/store/batch', body)
        response.map { |item_data| Models::StoreItem.new(item_data) }
      end

      def batch_delete(**params) # rubocop:disable Naming/PredicateMethod
        body = compact_params(params)
        @client.delete('/store/batch', body)
        true
      end
    end
  end
end
