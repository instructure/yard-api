require 'pathname'

include YARD::Templates::Helpers::ModuleHelper
include YARD::Templates::Helpers::FilterHelper
include YARD::Templates::Helpers::HtmlHelper

RouteHelper = YARD::Templates::Helpers::RouteHelper

def init
  resources = options[:objects]
    .group_by { |o| o.tags('API').first.text }
    .sort_by  { |o| o.first }
    .each { |resource, controllers| serialize_resource(resource, controllers) }
end

def serialize_resource(resource, controllers)
  Templates::Engine.with_serializer("#{topicize resource}.json", options[:serializer]) do
    JSON.pretty_generate({
      object: resource,
      api_objects: controllers.map do |controller|
        dump_api_objects(controller)
      end.flatten,
      methods: method_details_list(controllers)
    })
  end
end

def method_details_list(controllers)
  @meths = controllers.map do |controller|
    controller.meths(:inherited => false, :included => false)
  end.flatten

  @meths = run_verifier(@meths)

  @meths.map do |object, i|
    dump_object(object).tap do |object_info|
      object_info[:tags] = dump_object_tags(object)
    end
  end
end

def dump_api_objects(controller)
  (controller.tags(:object) + controller.tags(:model)).map do |obj|
    name, schema = obj.text.split(%r{\n+}, 2).map(&:strip)

    {
      controller: controller.name,
      name: name,
      schema: schema
    }
  end
end

def dump_object(object)
  {
    name: object.name,
    route: get_route(object),
    title: object.title,
    type: object.type,
    path: object.path,
    namespace: object.namespace.path,
    source: object.source,
    source_type: object.source_type,
    signature: object.signature,
    files: object.files,
    docstring: object.base_docstring,
    dynamic: object.dynamic,
    group: object.group,
    visibility: object.visibility
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
    # controller_path = "app/controllers/#{route.requirements[:controller]}_controller.rb"
    # controller_path = nil unless File.file?(Rails.root+controller_path)

    route_path = route.path.spec.to_s.gsub("(.:format)", "")
    verb = if route.verb.source =~ /\^?(\w*)\$/
      $1.upcase
    else
      route.verb.source
    end

    {
      path: route_path,
      verb: verb
    }
  end
end
