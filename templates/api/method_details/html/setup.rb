# require 'route_helper'

RouteHelper = YARD::Templates::Helpers::RouteHelper

def init
  sections :header, [:method_signature, T('docstring')]
end

def header
  routes = get_current_routes

  unless route = routes.first
    ::YARD::APIPlugin.log(
      "[error] Unable to find route for object: #{object}",
      ::Logger::ERROR
    )

    return
  end

  @props = {}
  @props[:method_link] = [
    'method',
    route.requirements[:controller],
    route.requirements[:action]
  ].join('.')

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
    {}.tap do |spec|
      spec[:path] = route.path.spec.to_s.gsub("(.:format)", "")
      spec[:verb] = route.verb.source =~ /\^?(\w*)\$/ ? $1.upcase : route.verb.source
    end
  end

  erb(:header)
end

def get_current_routes
  controller_name = object.parent.path.underscore
  controller_name.sub!("_controller", '') unless controller_name.include?('/')

  action = object.path.sub(/^.*#/, '').sub(/_with_.*$/, '')

  RouteHelper.api_methods_for_controller_and_action(controller_name, action)
end
