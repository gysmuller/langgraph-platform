module LanggraphPlatform
  class BaseClient
    def initialize(configuration)
      @configuration = configuration
      @http_client = build_http_client
    end

    def get(path, params = {})
      request(:get, path, params: params)
    end

    def post(path, body = {})
      request(:post, path, body: body)
    end

    def patch(path, body = {})
      request(:patch, path, body: body)
    end

    def put(path, body = {})
      request(:put, path, body: body)
    end

    def delete(path)
      request(:delete, path)
    end

    def stream(path, body = {}, &block)
      response = @http_client.headers(
        'Accept' => 'text/event-stream',
        'Cache-Control' => 'no-cache'
      ).timeout(@configuration.timeout).post("#{@configuration.base_url}#{path}", json: body)

      if block_given?
        stream_events(response, &block)
      else
        response
      end
    rescue HTTP::Error => e
      raise Errors::APIError, "Stream request failed: #{e.message}"
    end

    private

    def stream_events(response, &block)
      parser = EventStreamParser::Parser.new

      response.body.each do |chunk|
        parser.feed(chunk) do |type, data, id, reconnection_time|
          # Parse JSON data if present
          parsed_data = parse_data_safely(data)

          # Pass parameters directly to block
          block.call(type, parsed_data, id, reconnection_time)
        end
      end
    rescue StandardError => e
      warn "Error processing SSE stream: #{e.message}" if @configuration.debug
      raise
    end

    def parse_data_safely(data_string)
      return data_string if data_string.nil? || data_string.empty?

      MultiJson.load(data_string)
    rescue MultiJson::ParseError
      # Return as string if JSON parsing fails
      data_string
    end

    def build_http_client
      HTTP.headers(
        'Authorization' => "Bearer #{@configuration.api_key}",
        'User-Agent' => @configuration.user_agent,
        'Content-Type' => 'application/json'
      ).timeout(@configuration.timeout)
    end

    def request(method, path, params: {}, body: {})
      retries = 0

      begin
        url = "#{@configuration.base_url}#{path}"
        response = case method
                   when :get
                     @http_client.get(url, params: params)
                   when :post
                     @http_client.post(url, json: body)
                   when :patch
                     @http_client.patch(url, json: body)
                   when :put
                     @http_client.put(url, json: body)
                   when :delete
                     @http_client.delete(url)
                   end

        handle_response(response)
      rescue HTTP::Error => e
        retries += 1
        unless retries <= @configuration.retries
          raise Errors::APIError, "HTTP request failed after #{@configuration.retries} retries: #{e.message}"
        end

        sleep(2**retries)
        retry
      end
    end

    def handle_response(response) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
      case response.status
      when 200..299
        # Handle empty responses (e.g., 204 No Content)
        return nil if response.body.nil? || response.body.empty?

        response.parse
      when 400
        raise Errors::BadRequestError, extract_error_message(response)
      when 401
        raise Errors::UnauthorizedError, extract_error_message(response)
      when 404
        raise Errors::NotFoundError, extract_error_message(response)
      when 409
        raise Errors::ConflictError, extract_error_message(response)
      when 422
        raise Errors::ValidationError, extract_error_message(response)
      when 500..599
        raise Errors::ServerError, extract_error_message(response)
      else
        raise Errors::APIError, "Unexpected response status: #{response.status}"
      end
    end

    def extract_error_message(response)
      body = response.parse
      if body.is_a?(Hash) && body['error']
        body['error']
      elsif body.is_a?(Hash) && body['message']
        body['message']
      else
        body.to_s
      end
    rescue StandardError
      response.to_s
    end
  end
end
