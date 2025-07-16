module LanggraphPlatform
  module Resources
    class Mcp < BaseResource
      def call_tool(**params)
        params[:arguments] ||= {}
        body = compact_params(params)
        @client.post('/mcp/tools/call', body)
      end

      def list_tools
        @client.get('/mcp/tools')
      end

      def get_tool(tool_name)
        @client.get("/mcp/tools/#{tool_name}")
      end

      def list_resources
        @client.get('/mcp/resources')
      end

      def get_resource(**params)
        query_params = compact_params(params)
        @client.get('/mcp/resources/get', query_params)
      end

      def read_resource(**params)
        query_params = compact_params(params)
        @client.get('/mcp/resources/read', query_params)
      end

      def list_prompts
        @client.get('/mcp/prompts')
      end

      def get_prompt(**params)
        params[:arguments] ||= {}
        body = compact_params(params)
        @client.post('/mcp/prompts/get', body)
      end

      def complete_prompt(**params)
        params[:arguments] ||= {}
        body = compact_params(params)
        @client.post('/mcp/prompts/complete', body)
      end

      def send_log(**params)
        body = compact_params(params)
        @client.post('/mcp/logging/log', body)
      end
    end
  end
end
