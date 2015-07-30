require 'yard/templates/helpers/base_helper'

module YARD::Templates::Helpers::BaseHelper
  def api_options()
    YARD::APIPlugin.options
  end

  def lookup_appendix(title)
    appendix = nil

    logger.debug("Looking up appendix: #{title}")

    if object
      # try in the object scope
      appendix = YARD::Registry.at(".appendix.#{object.path}.#{title}")

      # try in the object's namespace scope
      if appendix.nil? && object.respond_to?(:namespace)
        appendix = YARD::Registry.at(".appendix.#{object.namespace.path}.#{title}")
      end
    end

    appendix
  end

  def tag_partial(name, tag, locals={})
    options[:tag] = tag
    locals.each_pair { |key, value| options[key] = value }
    out = erb(name)
    options.delete(:tag)
    locals.keys.each { |key| options.delete(key.to_sym) }
    out
  end

  def get_current_routes
    YARD::Templates::Helpers::RouteHelper.routes_for_yard_object(object)
  end

  def get_current_route
    get_current_routes.first
  end

  def schema_is_model?(schema)
    schema.has_key?('description') && schema.has_key?('properties')
  end

  def logger
    YARD::APIPlugin.logger
  end
end
