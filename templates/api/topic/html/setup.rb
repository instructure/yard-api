require 'json'

def init
  sections :header, [:topic_doc, :method_details_list, [T('method_details')]]
  @resource = object
  @beta = options[:controllers].any? { |c| c.tag('beta') }
end

def method_details_list
  @meths = options[:controllers].map { |c| c.meths(:inherited => false, :included => false) }.flatten
  @meths = run_verifier(@meths)
  erb(:method_details_list)
end

def topic_doc
  @docstring = options[:controllers].map { |c| c.docstring }.join("\n\n")
  @object = @object.dup
  def @object.source_type; nil; end
  @json_objects = options[:json_objects][@resource] || []
  erb(:topic_doc)
end

def properties_of_model(json)
  begin
    JSON::parse(json || '')['properties']
  rescue JSON::ParserError
    nil
  end
end

def word_wrap(text, col_width=80)
  text.gsub!( /(\S{#{col_width}})(?=\S)/, '\1 ' )
  text.gsub!( /(.{1,#{col_width}})(?:\s+|$)/, "\\1\n" )
  text
end

def indent(str, amount = 2, char = ' ')
  str.gsub(/^/, char * amount)
end

def render_comment(string, wrap = 75)
  string ? indent(word_wrap(string), 2, '/') : ''
end

def render_value(value, type = 'string')
  case type
  when 'integer', 'double', 'number' then value.to_s
  else %{"#{value}"}
  end
end

def render_properties(json)
  if properties = properties_of_model(json)
    "{\n" + indent(
    properties.map do |name, prop|
      "\n" + render_comment(prop['description']) +
      %{"#{name}": } + render_value(prop['example'], prop['type'])
    end.join(",\n")) +
    "\n}"
  end
end