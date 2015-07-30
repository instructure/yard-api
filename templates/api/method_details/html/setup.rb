# require 'route_helper'

RouteHelper = YARD::Templates::Helpers::RouteHelper

def init
  sections :header, [:method_signature, T('docstring')]

  super
end

def header
  routes = get_current_routes
  route = options[:current_route] = routes.first

  unless route
    ::YARD::APIPlugin.log(
      "[error] Unable to find route for object: #{object}",
      ::Logger::ERROR
    )

    return
  end

  @props = {}
  @props[:method_link] = url_for(object)

  @props[:subtopic] = (object.parent.tag('subtopic') || object.parent.tag('API')).text

  controller_path = "app/controllers/#{route.requirements[:controller]}_controller.rb"

  # TODO: can't we just test using object.file instead of relying on Rails ?
  controller_path = nil unless File.file?(Rails.root+controller_path)

  if controller_path
    @props[:path] = controller_path
    @props[:controller] = route.requirements[:controller].camelize
    @props[:action] = route.requirements[:action]
  end

  @props[:routes] = routes.map do |route|
    {
      path: RouteHelper.get_route_path(route),
      verb: RouteHelper.get_route_verb(route)
    }
  end

  erb(:header)
end