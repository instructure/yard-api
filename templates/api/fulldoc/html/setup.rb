require 'pathname'
require 'json'

include YARD::Templates::Helpers::ModuleHelper
include YARD::Templates::Helpers::FilterHelper

def init
  YARD::APIPlugin.logger.info "YARD-API: starting."

  options.serializer = YARD::APIPlugin::Serializer.new
  options.serializer.basepath = api_options.output

  options.objects.each do |object|
    object[:api_id] = object.tag('API').text.lines.first
  end

  options[:resources] = options[:objects].
    group_by { |o| o[:api_id] }.
    sort_by  { |o| o.first }

  build_json_objects_map
  generate_assets

  if api_options.one_file
    return serialize_onefile_index
  end

  serialize_index if File.exists?(api_options['readme'] || '')
  serialize_static_pages
  serialize_resource_index if api_options['resource_index']

  options.delete(:objects)

  options[:resources].each do |resource, controllers|
    controllers.each do |controller|
      if controller.is_a?(YARD::CodeObjects::NamespaceObject)
        co = YARD::CodeObjects::ClassObject.new(
          YARD::APIPlugin::Registry.root,
          controller[:api_id]
        )

        YARD::Registry.register co

        (controller.tags(:object) + controller.tags(:model)).each do |tag|
          tag_co = YARD::CodeObjects::APIObject.new(co, tag.text.lines[0].strip)
          tag_co.object = tag.object

          # Make an alias on the global API namespace, for convenience.
          # Now an object called "Bar" under the "Foo" controller can be
          # referenced using [API::Bar] as well as [API::Foo::Bar] which will
          # never face any conflicts.
          shortcut_tag_co = YARD::CodeObjects::APIObject.new(YARD::APIPlugin::Registry.root, tag.text.lines[0].strip)
          shortcut_tag_co.object = tag.object

          # We need to override #namespace because #url_for() uses it to
          # generate the url, which has to be done usign #object and not
          # #namespace (which points to P("API") and we want
          # P("API::#{tag.object.path}")).
          shortcut_tag_co.namespace = tag.object

          YARD::Registry.register(tag_co)
          YARD::Registry.register(shortcut_tag_co)
        end
      end
    end

    # debugger

    if controllers.length > 1
      debugger
    end

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
  YARD::APIPlugin.logger.info('=' * 80)
  YARD::APIPlugin.logger.info ">>> #{resource} <<< (#{controllers})"
  YARD::APIPlugin.logger.info('-' * 80)

  options[:object] = resource
  options[:controllers] = controllers

  controllers.each do |controller|
    Templates::Engine.with_serializer(controller, options.serializer) do
      T('layout').run(options)
    end
  end

  options.delete(:controllers)
  YARD::APIPlugin.logger.info('-' * 80)
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
      (controller.tags(:object) + controller.tags(:model)).each do |tag|
        name, json_string = tag.text.split(%r{\n+}, 2).map(&:strip)

        if json = parse_json(json_string)
          options[:json_objects_map][name] = topicize r
          options[:json_objects][r] ||= []
          options[:json_objects][r] << [name, json]
        end
      end
    end
  end
end

def parse_json(json_string)
  JSON::parse(json_string || '').tap do |json|
    validate_json_schema(json, ->(msg) {
      raise <<-MSG
        #{'=' * 32}
        #{msg.strip}
        #{'-' * 32}
        Offending JSON belongs to: "#{name}" in "#{tag.object.path}".
        #{'=' * 32}
      MSG
    })
  end
rescue JSON::ParserError => e
  YARD::APIPlugin.on_error(
    <<-MSG
    #{'*' * 32}
      A @#{tag.tag_name} docstring contains invalid JSON.
      Offending JSON belongs to "#{name}" in "#{tag.object.path}".
      ---
      #{tag}
      ---
      #{e}
    #{'*' * 32}
    MSG
  )

  nil
end

def validate_json_schema(schema, on_error)
  if schema_is_model?(schema)
    if !schema['description'].is_a?(String)
      on_error.call <<-MSG
        Expected "description" to be a String, got #{schema['description'].class}.
        Value: #{schema['description'].to_json}
      MSG
    end
  end
end
