module LanggraphPlatform
  module Models
    class Run
      attr_reader :run_id, :thread_id, :assistant_id, :created_at, :updated_at,
                  :status, :metadata, :kwargs, :multitask_strategy

      def initialize(attributes)
        @run_id = attributes['run_id']
        @thread_id = attributes['thread_id']
        @assistant_id = attributes['assistant_id']
        @created_at = parse_time(attributes['created_at'])
        @updated_at = parse_time(attributes['updated_at'])
        @status = attributes['status']
        @metadata = attributes['metadata'] || {}
        @kwargs = attributes['kwargs']
        @multitask_strategy = attributes['multitask_strategy']
      end

      def pending?
        @status == 'pending'
      end

      def running?
        @status == 'running'
      end

      def success?
        @status == 'success'
      end

      def error?
        @status == 'error'
      end

      def timeout?
        @status == 'timeout'
      end

      def interrupted?
        @status == 'interrupted'
      end

      def to_h
        {
          run_id: @run_id,
          thread_id: @thread_id,
          assistant_id: @assistant_id,
          created_at: @created_at,
          updated_at: @updated_at,
          status: @status,
          metadata: @metadata,
          kwargs: @kwargs,
          multitask_strategy: @multitask_strategy
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
