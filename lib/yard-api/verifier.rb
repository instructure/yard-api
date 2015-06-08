module YARD
  module APIPlugin
    class Verifier < ::YARD::Verifier
      def initialize(verbose=false)
        @verbose = verbose
        super()
      end

      def run(list)
        relevant = list.select { |o| relevant_object?(o) }

        if @verbose && relevant.any?
          log "#{relevant.length}/#{list.length} objects are relevant:"

          relevant.each do |object|
            log "\t- #{object.path}"
          end
        end

        relevant
      end

      def relevant_object?(object)
        case object.type
        when :root, :module, :constant
          false
        when :method, :class
          is_api = !object.tags('API').empty?
          is_internal = !object.tags('internal').empty?

          if @verbose && !is_api && !is_internal
            log "Resource #{object} will be ignored as it contains no @API tag."
          end

          is_api && !is_internal
        else
          object.parent.nil? && relevant_object?(object.parent)
        end
      end

      def log(*args)
        ::YARD::APIPlugin.log(*args)
      end
    end
  end
end
