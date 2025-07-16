module LanggraphPlatform
  module Models
    class Cron
      attr_reader :cron_id, :assistant_id, :thread_id, :schedule, :payload,
                  :created_at, :updated_at, :next_run_time, :enabled

      def initialize(attributes)
        @cron_id = attributes['cron_id']
        @assistant_id = attributes['assistant_id']
        @thread_id = attributes['thread_id']
        @schedule = attributes['schedule']
        @payload = attributes['payload']
        @created_at = parse_time(attributes['created_at'])
        @updated_at = parse_time(attributes['updated_at'])
        @next_run_time = parse_time(attributes['next_run_time'])
        @enabled = attributes['enabled']
      end

      def enabled?
        @enabled == true
      end

      def disabled?
        !enabled?
      end

      def to_h
        {
          cron_id: @cron_id,
          assistant_id: @assistant_id,
          thread_id: @thread_id,
          schedule: @schedule,
          payload: @payload,
          created_at: @created_at,
          updated_at: @updated_at,
          next_run_time: @next_run_time,
          enabled: @enabled
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
