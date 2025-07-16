module LanggraphPlatform
  module Models
    class StoreItem
      attr_reader :namespace, :key, :value, :created_at, :updated_at

      def initialize(attributes)
        @namespace = attributes['namespace']
        @key = attributes['key']
        @value = attributes['value']
        @created_at = parse_time(attributes['created_at'])
        @updated_at = parse_time(attributes['updated_at'])
      end

      def to_h
        {
          namespace: @namespace,
          key: @key,
          value: @value,
          created_at: @created_at,
          updated_at: @updated_at
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
