module YARD
  module APIPlugin
    class Verifier < ::YARD::Verifier
      def initialize(verbose=false)
        @verbose = verbose
        @routes = {}
        super()
      end

      def run(list)
        relevant = list.select { |o| relevant_object?(o) }

        if @verbose && relevant.any?
          logger.debug "#{relevant.length}/#{list.length} objects are relevant:"

          relevant.each do |object|
            logger.debug "\t- #{object.path}"
          end
        end

        relevant
      end

      def relevant_object?(object)
        doc_include_internal = !!YARD::APIPlugin.options[:include_internal]
        case object.type
        when :root, :module, :constant
          false
        when :api
          true
        when :method
          return false if object.has_tag?(:internal) && !doc_include_internal || !object.has_tag?(:API)
          routes = @routes[object.object_id]
          routes ||= begin
            @routes[object.object_id] = YARD::Templates::Helpers::RouteHelper.routes_for_yard_object(object)
          end

          if routes.empty?
            logger.warn (
              "API Endpoint #{object.path}# has no routes defined " +
              "ib routes.rb and will be ignored."
            )
          end

          routes.any?
        when :class
          return false if object.has_tag?(:internal) && !doc_include_internal || !object.has_tag?(:API)
          true
        else
          object.parent.nil? && relevant_object?(object.parent)
        end
      end

      def logger
        ::YARD::APIPlugin.logger
      end
    end
  end
end
