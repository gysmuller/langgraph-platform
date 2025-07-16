module LanggraphPlatform
  module Resources
    class BaseResource
      def initialize(client)
        @client = client
      end

      private

      attr_reader :client

      def handle_response(response, model_class = nil)
        return response unless model_class

        if response.is_a?(Array)
          response.map { |item| model_class.new(item) }
        else
          model_class.new(response)
        end
      end

      def compact_params(params)
        params.compact
      end
    end
  end
end
