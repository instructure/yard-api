require 'pathname'

include YARD::Templates::Helpers::ModuleHelper
include YARD::Templates::Helpers::FilterHelper

def init
  options[:resources] = options[:objects].
    group_by { |o| o.tags('API').first.text.split("\n").first }.
    sort_by  { |o| o.first }

  build_json_objects_map
  generate_assets

  if api_options.one_file
    return serialize_onefile_index
  end

  serialize_index if File.exists?(api_options['readme'])
  serialize_static_pages
  serialize_resource_index if api_options['resource_index']

  options.delete(:objects)

  options[:resources].each do |resource, controllers|
    serialize_resource(resource, controllers)
  end
end

def serialize(object)
  options[:object] = object
  Templates::Engine.with_serializer(object, options[:serializer]) do
    T('layout').run(options)
  end
end

def serialize_resource(resource, controllers)
  options[:object] = resource
  options[:controllers] = controllers
  Templates::Engine.with_serializer("#{topicize resource}.html", options[:serializer]) do
    T('layout').run(options)
  end
  options.delete(:controllers)
end

def serialize_index
  options[:file] = api_options['readme']
  serialize('index.html')
  options.delete(:file)
end

def serialize_onefile_index
  options[:all_resources] = true

  Templates::Engine.with_serializer('index.html', options[:serializer]) do
    T('onefile').run(options)
  end

  options.delete(:all_resources)
end

def serialize_resource_index
  options[:all_resources] = true

  Templates::Engine.with_serializer("all_resources.html", options[:serializer]) do
    T('layout').run(options)
  end

  options.delete(:all_resources)
end

def asset(path, content)
  options[:serializer].serialize(path, content) if options[:serializer]
end

def generate_assets
  layout = Object.new.extend(T('layout'))

  [].concat(layout.stylesheets).concat(layout.javascripts).uniq.each do |file|
    asset(file, file(file, true))
  end
end

def serialize_static_pages
  static_pages.each do |page|
    options[:file] = page[:src]
    serialize(page[:filename])
    options.delete(:file)
  end
end

def build_json_objects_map
  options[:json_objects_map] = {}
  options[:json_objects] = {}
  options[:resources].each do |r,cs|
    cs.each do |controller|
      (controller.tags(:object) + controller.tags(:model)).each do |obj|
        name, json = obj.text.split(%r{\n+}, 2).map(&:strip)
        options[:json_objects_map][name] = topicize r
        options[:json_objects][r] ||= []
        options[:json_objects][r] << [name, json]
      end
    end
  end
end
