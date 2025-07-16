module LanggraphPlatform
  class Configuration
    attr_accessor :api_key, :base_url, :timeout, :retries, :user_agent

    def initialize(api_key: nil, base_url: nil)
      @api_key = api_key || ENV.fetch('LANGGRAPH_API_KEY', nil)
      @base_url = base_url || ENV['LANGGRAPH_BASE_URL'] || 'https://api.langchain.com'
      @timeout = 30
      @retries = 3
      @user_agent = "langgraph-platform-ruby/#{VERSION}"
    end

    def valid?
      !@api_key.nil? && !@api_key.empty?
    end
  end
end
