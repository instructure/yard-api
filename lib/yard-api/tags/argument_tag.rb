require 'yaml'

module YARD::APIPlugin::Tags
  class ArgumentTag < YARD::Tags::Tag
    attr_reader :accepted_values, :is_required

    RE_ARRAY_LITERAL = /\[[^\]]+\]/
    RE_ARRAY_TYPE = /^#{RE_ARRAY_LITERAL}$/
    RE_ACCEPTED_VALUES_PREFIXES = /
      accepted\svalues |
      accepts |
      possible\svalues
    /imx
    RE_ACCEPTED_VALUES_STR = /
      #{RE_ACCEPTED_VALUES_PREFIXES}:\s*(#{RE_ARRAY_LITERAL})
    /mx

    def initialize(name, buf)
      YARD::Tags::Library.instance.tag_create(:attr, buf).tap do |tag|
        super(:argument, tag.text, tag.types, tag.name)

        @is_required = parse_is_required(@types)
        @accepted_values = parse_accepted_values(@types, @text)
      end
    end

    def unscoped_name
      if scope_tag = @object.tag(:argument_scope)
        if @name =~ /^#{scope_tag.text}\[([^\]]+)\]$/
          $1
        else
          @name
        end
      else
        @name
      end
    end

    private

    def parse_is_required(types)
      strict = !!YARD::APIPlugin.options.strict_arguments
      specifier = Array(types).detect { |typestr| typestr.match(/optional|required/i) }

      if specifier
        types.delete(specifier)

        return true if specifier.downcase == 'required'
        return false if specifier.downcase == 'optional'
      end

      strict
    end

    def parse_accepted_values(types, text)
      str = if Array(types).any? && types.last.match(RE_ARRAY_TYPE)
        types.pop
      elsif text && text.match(RE_ACCEPTED_VALUES_STR)
        $1
      end

      if str
        begin
          YAML.load(str)
        rescue Exception => e
          YARD::APIPlugin.on_error <<-Error
            Unable to parse accepted values for @argument tag.
            Error: #{exception}
            Offending docstring:
            #{text}
          Error

          return nil
        end
      end
    end
  end
end