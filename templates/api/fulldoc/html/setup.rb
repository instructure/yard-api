require 'pathname'
require 'json'

include YARD::Templates::Helpers::ModuleHelper
include YARD::Templates::Helpers::FilterHelper

def init
  logger.info "YARD-API: starting."

  options.serializer ||= YARD::APIPlugin::Serializer.new
  options.serializer.basepath = api_options.output

  options[:resources] = options.objects.
    group_by { |o| o[:api_id] }.
    sort_by { |o| o.first }

  generate_endpoint_list(options[:resources])
  generate_code_objects(options[:resources])
  generate_json_object_map
  generate_assets

  if api_options.one_file
    serialize_onefile_index
  else
    serialize_index if File.exists?(api_options['readme'] || '')
    serialize_static_pages
    serialize_resource_index if api_options['resource_index']

    options[:resources].each do |resource, controllers|
      serialize_resource(resource, controllers)
    end
  end
end

def serialize(object)
  options[:object] = object

  Templates::Engine.with_serializer(object, options[:serializer]) do
    T('layout').run(options)
  end

  options.delete(:object)
end

def serialize_resource(resource, controllers)
  logger.debug "[=- #{resource} (#{controllers}) -=]"

  options[:object] = resource
  options[:controllers] = controllers

  controllers.each do |controller|
    Templates::Engine.with_serializer(controller, options.serializer) do
      T('layout').run(options)
    end
  end

  options.delete(:object)
  options.delete(:controllers)

  logger.info('-' * 80)
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
  options[:object] = 'all_resources.html'

  Templates::Engine.with_serializer("all_resources.html", options[:serializer]) do
    T('layout').run(options)
  end

  options.delete(:object)
  options.delete(:all_resources)
end

def generate_assets
  layout = Object.new.extend(T('layout'))

  (layout.stylesheets + layout.javascripts).uniq.each do |file|
    options.serializer.serialize(file, file(file, true))
  end
end

def serialize_static_pages
  static_pages.each do |page|
    options[:file] = page[:src]
    serialize(page[:filename])
    options.delete(:file)
  end
end

def generate_code_objects(resources)
  resources.each do |resource, controllers|
    controllers.each do |controller|
      if controller.is_a?(YARD::CodeObjects::NamespaceObject)
        co = YARD::CodeObjects::ClassObject.new(
          YARD::APIPlugin::Registry.root,
          controller[:api_id]
        )

        YARD::Registry.register co

        (controller.tags(:object) + controller.tags(:model)).each do |tag|
          id = YARD::CodeObjects::APIObject.sanitize_id(tag.text.lines.first.strip)
          tag_co = YARD::CodeObjects::APIObject.new(co, id)
          tag_co.object = tag.object

          # Make an alias on the global API namespace, for convenience.
          # Now an object called "Bar" under the "Foo" controller can be
          # referenced using [API::Bar] as well as [API::Foo::Bar] which will
          # never face any conflicts.
          shortcut_tag_co = YARD::CodeObjects::APIObject.new(YARD::APIPlugin::Registry.root, id)
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
  end
end

def generate_endpoint_list(resources)
  options[:endpoints] ||= begin
    resources.reduce({}) do |hsh, (resource, controllers)|
      meths = controllers.map do |controller|
        controller.meths(:inherited => false, :included => false)
      end

      hsh[resource] = run_verifier(meths.flatten)
      hsh
    end
  end
end

def generate_json_object_map
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
