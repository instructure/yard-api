# require 'route_helper'

RouteHelper = YARD::Templates::Helpers::RouteHelper
def init
  get_routes
  sections :header, [:method_signature, T('docstring')]
end

def header
  get_routes
  @subtopic = (object.parent.tag('subtopic') || object.parent.tag('API')).text

  unless route = @routes.first
    puts "[error] Unable to find route for object: #{object}"
    return
  end

  @method_link = "method.#{route.requirements[:controller]}.#{route.requirements[:action]}"
  @beta = object.tag('beta') || object.parent.tag('beta')
  erb(:header)
end

def get_routes
  @controller = object.parent.path.underscore
  @controller.sub!("_controller", '') unless @controller.include?('/')

  @action = object.path.sub(/^.*#/, '')
  @action = @action.sub(/_with_.*$/, '')
  @routes = RouteHelper.api_methods_for_controller_and_action(@controller, @action)
  @route = @routes.first
  if @route.present?
    @controller_path = "app/controllers/#{@route.requirements[:controller]}_controller.rb"
    @controller_path = nil unless File.file?(Rails.root+@controller_path)
  end

  puts "Routes: #{@routes}"
end
