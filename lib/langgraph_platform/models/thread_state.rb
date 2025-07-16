module LanggraphPlatform
  module Models
    class ThreadState
      attr_reader :values, :next, :checkpoint, :metadata, :created_at, :parent_checkpoint

      def initialize(attributes)
        @values = attributes['values']
        @next = attributes['next']
        @checkpoint = attributes['checkpoint']
        @metadata = attributes['metadata'] || {}
        @created_at = parse_time(attributes['created_at'])
        @parent_checkpoint = attributes['parent_checkpoint']
      end

      def to_h
        {
          values: @values,
          next: @next,
          checkpoint: @checkpoint,
          metadata: @metadata,
          created_at: @created_at,
          parent_checkpoint: @parent_checkpoint
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
