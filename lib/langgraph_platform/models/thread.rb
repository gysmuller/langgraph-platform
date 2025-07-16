module LanggraphPlatform
  module Models
    class Thread
      attr_reader :thread_id, :created_at, :updated_at, :metadata, :status, :values

      def initialize(attributes)
        @thread_id = attributes['thread_id']
        @created_at = parse_time(attributes['created_at'])
        @updated_at = parse_time(attributes['updated_at'])
        @metadata = attributes['metadata'] || {}
        @status = attributes['status']
        @values = attributes['values']
      end

      def idle?
        @status == 'idle'
      end

      def busy?
        @status == 'busy'
      end

      def interrupted?
        @status == 'interrupted'
      end

      def error?
        @status == 'error'
      end

      def to_h
        {
          thread_id: @thread_id,
          created_at: @created_at,
          updated_at: @updated_at,
          metadata: @metadata,
          status: @status,
          values: @values
        }
      end

      def to_json(*args)
        to_h.to_json(*args)
      end

      private

      def parse_time(time_string)
        return nil if time_string.nil?

        Time.parse(time_string)
      rescue ArgumentError
        nil
      end
    end
  end
end
