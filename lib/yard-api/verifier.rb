module YARD
  module APIPlugin
    class Verifier < ::YARD::Verifier
      def run(list)
        puts "Filtering #{list.length} objects:"
        filtered = list.select { |o| relevant_object?(o) }
        puts "\t#{filtered.length} relevant objects found."
        filtered
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
