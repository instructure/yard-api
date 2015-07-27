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
          return false if object.tags('internal').any?

          object.tags('API').any?.tap do |is_api|
            if @verbose
              log "Resource #{object} will be ignored as it contains no @API tag."
            end
          end
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
