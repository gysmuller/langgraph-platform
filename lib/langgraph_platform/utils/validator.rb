module LanggraphPlatform
  module Utils
    class Validator
      def self.validate_required_params(params, required_keys)
        missing_keys = required_keys - params.keys

        return if missing_keys.empty?

        raise ArgumentError, "Missing required parameters: #{missing_keys.join(', ')}"
      end

      def self.validate_param_types(params, type_map)
        type_map.each do |key, expected_type|
          value = params[key]
          next if value.nil?

          unless value.is_a?(expected_type)
            raise ArgumentError, "Parameter '#{key}' must be of type #{expected_type}, got #{value.class}"
          end
        end
      end

      def self.validate_enum_values(params, enum_map)
        enum_map.each do |key, allowed_values|
          value = params[key]
          next if value.nil?

          unless allowed_values.include?(value)
            raise ArgumentError, "Parameter '#{key}' must be one of #{allowed_values.join(', ')}, got '#{value}'"
          end
        end
      end

      def self.validate_assistant_id(assistant_id)
        return unless assistant_id.nil? || assistant_id.to_s.strip.empty?

        raise ArgumentError, 'Assistant ID cannot be nil or empty'
      end

      def self.validate_thread_id(thread_id)
        return unless thread_id.nil? || thread_id.to_s.strip.empty?

        raise ArgumentError, 'Thread ID cannot be nil or empty'
      end

      def self.validate_run_id(run_id)
        return unless run_id.nil? || run_id.to_s.strip.empty?

        raise ArgumentError, 'Run ID cannot be nil or empty'
      end

      def self.validate_cron_schedule(schedule)
        raise ArgumentError, 'Cron schedule cannot be nil or empty' if schedule.nil? || schedule.to_s.strip.empty?

        # Basic cron validation - should have 5 or 6 parts
        parts = schedule.split(' ')
        return if [5, 6].include?(parts.length)

        raise ArgumentError, "Invalid cron schedule format. Expected 5 or 6 parts, got #{parts.length}"
      end

      def self.validate_pagination_params(limit, offset)
        raise ArgumentError, 'Limit must be a positive integer' if limit && (!limit.is_a?(Integer) || limit < 1)

        return unless offset && (!offset.is_a?(Integer) || offset.negative?)

        raise ArgumentError, 'Offset must be a non-negative integer'
      end

      def self.validate_metadata(metadata)
        return if metadata.is_a?(Hash)

        raise ArgumentError, 'Metadata must be a Hash'
      end
    end
  end
end
