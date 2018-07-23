require 'pathname'

include YARD::Templates::Helpers::ModuleHelper
include YARD::Templates::Helpers::FilterHelper
include YARD::Templates::Helpers::HtmlHelper

RouteHelper = YARD::Templates::Helpers::RouteHelper
ArgumentTag = YARD::APIPlugin::Tags::ArgumentTag

def init
  resources = options[:objects]
    .group_by { |o| o.tags('API').first.text }
    .sort_by  { |o| o.first }
    .each { |resource, controllers| serialize_resource(resource, controllers) }
end

def serialize_resource(resource, controllers)
  Templates::Engine.with_serializer("#{topicize resource}.json", options[:serializer]) do
    {
      id: topicize(resource),
      title: resource,
      text: controllers.map { |c| c.docstring }.join("\n\n"),
      objects: controllers.map { |c| dump_controller_objects(c) }.flatten,
      endpoints: dump_resource_endpoints(controllers)
    }.to_json
  end
end

def dump_resource_endpoints(controllers)
  meths = controllers.map do |controller|
    controller.meths(:inherited => false, :included => false)
  end.flatten

  meths = run_verifier(meths)

  meths.map do |object, i|
    dump_endpoint(object).tap do |object_info|
      object_info[:tags] = dump_object_tags(object)
    end
  end
end

def dump_controller_objects(controller)
  (controller.tags(:object) + controller.tags(:model)).map do |obj|
    dump_object(obj)
  end
end

def dump_object(obj)
  title, spec = obj.text.split(%r{\n+}, 2).map(&:strip)
  spec = JSON.parse(spec)
  schema = spec.has_key?('properties') ? spec['properties'] : spec

  schema_tags = schema.map do |(prop_name, prop)|
    is_required = prop.has_key?('required') ? prop['required'] : false
    is_required_str = is_required ? 'Required' : 'Optional'

    {
      "name" => prop_name,
      "types" => Array(prop["type"]),
      "is_required" => !!prop["required"],
      "text" => prop.fetch('description', ''),
      "example" => prop['example'],
      "accepted_values" => Array(
        first_in([
          "accepted values",
          "accepted_values",
          "accepts",
          "accepted",
          "acceptable values",
        ], prop)
      )
    }
  end

  {
    id: topicize("#{obj.object.path}::#{title}"),
    scoped_id: topicize(title),
    title: title,
    text: spec['description'] || '',
    controller: obj.object.path,
    schema: schema_tags
  }
end

def dump_endpoint(endpoint)
  title = endpoint.tag(:API).text

  {
    id: topicize(endpoint.path),
    scoped_id: topicize(title),
    name: endpoint.name,
    title: title,
    text: endpoint.base_docstring,
    controller: endpoint.namespace.path,
    route: get_route(endpoint),
    type: endpoint.type,
    source: endpoint.source,
    source_type: endpoint.source_type,
    signature: endpoint.signature,
    files: endpoint.files,
    dynamic: endpoint.dynamic,
    group: endpoint.group,
    visibility: endpoint.visibility
  }
end

def dump_object_tags(object)
  object.tags.map do |tag|
    tag.instance_variables.reduce({}) do |out, var|
      key = var.to_s.sub('@', '')

      if tag.respond_to?(key) && key != 'object'
        out[key] = tag.send(key)
      end

      out
    end
  end
end

def get_route(object)
  controller = object.parent.path.underscore
  controller.sub!("_controller", '') unless controller.include?('/')

  action = object.path.sub(/^.*#/, '')
  action = action.sub(/_with_.*$/, '')
  routes = RouteHelper.api_methods_for_controller_and_action(controller, action)
  route = routes.first

  if route.present?
    verb = if route.verb.source =~ /\^?(\w*)\$/
      $1.upcase
    else
      route.verb.source
    end

    {
      path: route.path.spec.to_s.gsub("(.:format)", ""),
      verb: verb
    }
  end
end

def first_in(keys, obj)
  obj[keys.detect { |k| obj.key?(k) }]
end