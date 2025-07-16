module LanggraphPlatform
  module Resources
    class Crons < BaseResource
      def create(**params)
        params[:payload] ||= {}
        body = compact_params(params)
        response = @client.post('/crons', body)
        Models::Cron.new(response)
      end

      def find(cron_id)
        response = @client.get("/crons/#{cron_id}")
        Models::Cron.new(response)
      end

      def update(cron_id, **params)
        body = compact_params(params)
        response = @client.patch("/crons/#{cron_id}", body)
        Models::Cron.new(response)
      end

      def delete(cron_id) # rubocop:disable Naming/PredicateMethod
        @client.delete("/crons/#{cron_id}")
        true
      end

      def list(**params)
        params[:limit] ||= 10
        params[:offset] ||= 0
        query_params = compact_params(params)
        response = @client.get('/crons', query_params)
        response.map { |cron_data| Models::Cron.new(cron_data) }
      end

      def search(**params)
        params[:limit] ||= 10
        params[:offset] ||= 0
        body = compact_params(params)
        response = @client.post('/crons/search', body)
        response.map { |cron_data| Models::Cron.new(cron_data) }
      end

      def enable(cron_id) # rubocop:disable Naming/PredicateMethod
        @client.post("/crons/#{cron_id}/enable")
        true
      end

      def disable(cron_id) # rubocop:disable Naming/PredicateMethod
        @client.post("/crons/#{cron_id}/disable")
        true
      end
    end
  end
end
