module LanggraphPlatform
  module Utils
    class Paginator
      include Enumerable

      def initialize(resource, method, *args, **kwargs)
        @resource = resource
        @method = method
        @args = args
        @kwargs = kwargs
        @limit = kwargs[:limit] || 10
        @offset = kwargs[:offset] || 0
      end

      def each(&block)
        return enum_for(:each) unless block_given?

        current_offset = @offset

        loop do
          params = @kwargs.merge(limit: @limit, offset: current_offset)
          results = @resource.send(@method, *@args, **params)

          break if results.empty?

          results.each(&block)

          break if results.length < @limit

          current_offset += @limit
        end
      end

      def first(count = nil)
        if count
          take(count)
        else
          params = @kwargs.merge(limit: 1, offset: @offset)
          results = @resource.send(@method, *@args, **params)
          results.first
        end
      end

      def page(page_number, per_page = @limit)
        offset = (page_number - 1) * per_page
        params = @kwargs.merge(limit: per_page, offset: offset)
        @resource.send(@method, *@args, **params)
      end

      def count
        # TODO: Implement count method
        nil
      end

      def all
        to_a
      end
    end
  end
end
