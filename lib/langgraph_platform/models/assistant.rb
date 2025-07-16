module LanggraphPlatform
  module Models
    class Assistant
      attr_reader :assistant_id, :graph_id, :config, :created_at, :updated_at,
                  :metadata, :version, :name, :description

      def initialize(attributes)
        @assistant_id = attributes['assistant_id']
        @graph_id = attributes['graph_id']
        @config = attributes['config']
        @created_at = parse_time(attributes['created_at'])
        @updated_at = parse_time(attributes['updated_at'])
        @metadata = attributes['metadata'] || {}
        @version = attributes['version']
        @name = attributes['name']
        @description = attributes['description']
      end

      def to_h
        {
          assistant_id: @assistant_id,
          graph_id: @graph_id,
          config: @config,
          created_at: @created_at,
          updated_at: @updated_at,
          metadata: @metadata,
          version: @version,
          name: @name,
          description: @description
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
