require 'yard/code_objects/class_object'

module YARD::CodeObjects
  class ClassObject < NamespaceObject
    attr_reader :api_id

    def api_id
      @api_id ||= begin
        if tag = tag('API')
          tag.text.lines.first
        end
      end
    end

    def title
      api_id
    end
  end
end