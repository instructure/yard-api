require 'yaml'

module YARD::APIPlugin::Tags
  class ArgumentTag < YARD::Tags::Tag
    attr_reader :accepted_values, :is_required

    RE_NAME = /^([\S]+)/
    RE_ARRAY_LITERAL = /\[[^\]]+\]/
    RE_ARRAY_TYPE = /^#{RE_ARRAY_LITERAL}$/
    RE_REQUIRED_OPTIONAL = /required|optional/i
    RE_ACCEPTED_VALUES_PREFIXES = /
      accepted\svalues |
      accepts |
      possible\svalues
    /imx
    RE_ACCEPTED_VALUES_STR = /
      #{RE_ACCEPTED_VALUES_PREFIXES}:\s*(#{RE_ARRAY_LITERAL})
    /mx

    def initialize(name, buf)
      name = nil

      # If the name specifier is written before the types and contains brackets,
      # YARD will not properly parse the attributes (it doesn't even say that it
      # supports this syntax so), something like this:
      #
      #   @argument shirt[size] [String]
      #
      # We convert the name to use underscores instead and YARD does its magic!
      # Once the tag is parsed, we'll use the original name.
      #
      # @since 0.1.7
      if buf[0] != '[' && YARD::APIPlugin.options.leading_argument_name_fix
        arg_name = buf.match(RE_NAME).captures.first
        buf.sub!(arg_name, arg_name.gsub(/\W/, '_'))
        name = arg_name
      end

      YARD::Tags::Library.instance.tag_create(:attr, buf).tap do |tag|
        super(:argument, tag.text, tag.types, name || tag.name)

        @types ||= []
        @text ||= ''

        @is_required = parse_is_required(@types)
        @accepted_values = parse_accepted_values(@types, @text)
      end
    end

    def unscoped_name
      scope_tag = @object.tag(:argument_scope)

      if scope_tag && @name =~ /^#{scope_tag.text}\[([^\]]+)\]$/
        $1
      else
        @name
      end
    end

    private

    def parse_is_required(types=[])
      strict = !!YARD::APIPlugin.options.strict_arguments
      specifier = types.detect { |typestr| typestr.match(RE_REQUIRED_OPTIONAL) }

      if specifier
        types.delete(specifier)

        if specifier.downcase == 'required'
          return true
        elsif specifier.downcase == 'optional'
          return false
        end
      end

      strict
    end

    def parse_accepted_values(types=[], text='')
      # values specified after the type, i.e.:
      #
      #   @argument [String, ["S","M","L"]] size
      #
      str = if types.any? && types.last.match(RE_ARRAY_TYPE)
        types.pop
      # otherwise, look for them in the docstring, e.g.:
      #
      #   @argument [String] size
      #    Accepts ["S","M","L"]
      #
      elsif text.match(RE_ACCEPTED_VALUES_STR)
        $1
      end

      if str
        begin
          # some people prefer to use the pipe (|) to separate the values
          YAML.load(str.to_s.gsub('|', ','))
        rescue Exception => e
          YARD::APIPlugin.on_error <<-Error
            Unable to parse accepted values for @argument tag.
            Error:
            #{e.class}: #{e.message}
            Offending docstring:
            #{text}
            Accepted values string: '#{str}'
          Error

          return nil
        end
      end
    end
  end
end