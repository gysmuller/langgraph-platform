module LanggraphPlatform
  module Errors
    class APIError < StandardError
      attr_reader :message, :status_code

      def initialize(message, status_code = nil)
        @message = message
        @status_code = status_code
        super(message)
      end
    end

    class BadRequestError < APIError
      def initialize(message)
        super(message, 400)
      end
    end

    class UnauthorizedError < APIError
      def initialize(message)
        super(message, 401)
      end
    end

    class NotFoundError < APIError
      def initialize(message)
        super(message, 404)
      end
    end

    class ConflictError < APIError
      def initialize(message)
        super(message, 409)
      end
    end

    class ValidationError < APIError
      def initialize(message)
        super(message, 422)
      end
    end

    class ServerError < APIError
      def initialize(message)
        super(message, 500)
      end
    end
  end
end
