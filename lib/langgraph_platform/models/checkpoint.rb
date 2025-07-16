module LanggraphPlatform
  module Models
    class Checkpoint
      attr_reader :checkpoint_id, :thread_id, :checkpoint_ns, :checkpoint_map,
                  :parent_checkpoint_id, :created_at

      def initialize(attributes)
        @checkpoint_id = attributes['checkpoint_id']
        @thread_id = attributes['thread_id']
        @checkpoint_ns = attributes['checkpoint_ns']
        @checkpoint_map = attributes['checkpoint_map']
        @parent_checkpoint_id = attributes['parent_checkpoint_id']
        @created_at = parse_time(attributes['created_at'])
      end

      def to_h
        {
          checkpoint_id: @checkpoint_id,
          thread_id: @thread_id,
          checkpoint_ns: @checkpoint_ns,
          checkpoint_map: @checkpoint_map,
          parent_checkpoint_id: @parent_checkpoint_id,
          created_at: @created_at
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
