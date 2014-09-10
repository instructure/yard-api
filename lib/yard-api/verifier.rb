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
          puts "#{relevant.length}/#{list.length} objects are relevant:"
          relevant.each do |object|
            puts "\t- #{object.path}"
          end
        end

        relevant
      end

      def relevant_object?(object)
        case object.type
        when :root, :module, :constant
          false
        when :method, :class
          !object.tags('API').empty? && object.tags('internal').empty?
        else
          object.parent.nil? && relevant_object?(object.parent)
        end
      end
    end
  end
end
