module LanggraphPlatform
  class Client
    attr_reader :assistants, :threads, :runs, :crons, :store, :mcp, :configuration

    def initialize(api_key: nil, base_url: nil, **options)
      @configuration = Configuration.new(api_key: api_key, base_url: base_url)
      @configuration.timeout = options[:timeout] if options[:timeout]
      @configuration.retries = options[:retries] if options[:retries]
      @configuration.user_agent = options[:user_agent] if options[:user_agent]

      validate_configuration!

      @http_client = BaseClient.new(@configuration)

      initialize_resources
    end

    def configure
      yield(@configuration) if block_given?
      @http_client = BaseClient.new(@configuration)
      initialize_resources
    end

    private

    def validate_configuration!
      return if @configuration.valid?

      raise Errors::UnauthorizedError,
            'API key is required. Set it via the api_key parameter or LANGGRAPH_API_KEY environment variable.'
    end

    def initialize_resources
      @assistants = Resources::Assistants.new(@http_client)
      @threads = Resources::Threads.new(@http_client)
      @runs = Resources::Runs.new(@http_client)
      @crons = Resources::Crons.new(@http_client)
      @store = Resources::Store.new(@http_client)
      @mcp = Resources::Mcp.new(@http_client)
    end
  end
end
