def init
  super

  sections *[
    :emits,
    :note,
    :warning,
    :argument,
    :request_field,
    :response_field,
    :example_request,
    :example_response,
    :throws,
    :see,
    :returns,
    :no_content,
  ]
end

def see
  return unless object.has_tag?(:see)
  erb(:see)
end

def request_field
  generic_tag :request_field
end

def response_field
  generic_tag :response_field
end

def throws
  @error_tags = object.tags(:throws)

  if @error_tags.any?
    erb('throws')
  end
end

def emits
  @emits = object.tags(:emits)

  if @emits.any?
    erb('emits')
  end
end

def argument
  argument_tags = object.tags(:argument)

  if argument_tags.any?
    options[:argument_tags] = argument_tags
    erb('argument')
  end
end

def returns
  return unless object.has_tag?(:returns)
  response_info = object.tag(:returns)
  case response_info.text
  when %r{\[(.*)\]}
    @object_name = $1.strip
    @is_list = true
  else
    @object_name = response_info.text.strip
    @is_list = false
  end

  # if @object_name =~ /\{(\S+)\}/
  #   @object_name = $1
  # end

  @resource_name = options[:json_objects_map][@object_name]
  return unless @resource_name
  erb(:returns)
end

def generic_tag(name, opts = {})
  return unless object.has_tag?(name)
  @no_names = true if opts[:no_names]
  @no_types = true if opts[:no_types]
  @label = opts[:label]
  @name = name
  out = erb('generic_tag')
  @no_names, @no_types = nil, nil
  out
end

