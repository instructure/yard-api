require 'json'

def init
  sections :header, [:topic_doc, :method_details_list, [T('method_details')]]
  @endpoints = options[:endpoints][object]

  super
end

def method_details_list
  erb(:method_details_list)
end

def topic_doc
  @docstring = options[:controllers].map { |c| c.docstring }.join("\n\n")
  @json_objects = options[:json_objects][object] || []
  erb(:topic_doc)
end

def properties_of_model(json)
  begin
    JSON::parse(json || '')['properties']
  rescue JSON::ParserError
    nil
  end
end

def properties_of_model_as_tags(json)
  props = json.has_key?('properties') ? json['properties'] : json
  props.reduce([]) do |tags, (id, prop)|
    is_required = prop.has_key?('required') ? prop['required'] : false
    is_required_str = is_required ? 'Required' : 'Optional'

    tag = YARD::APIPlugin::Tags::ArgumentTag.new(
      nil,
      "[#{is_required_str}, #{prop['type']}] #{id}\n #{prop['description']}"
    )

    tags << tag
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