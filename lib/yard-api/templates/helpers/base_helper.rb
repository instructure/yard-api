require 'yard/templates/helpers/base_helper'

module YARD::Templates::Helpers::BaseHelper
  def api_options()
    YARD::APIPlugin.options
  end

  def linkify_with_api(*args)
    # References to controller actions
    #
    # Syntax: api:ControllerName#method_name [TITLE OVERRIDE]
    #
    # @example Explicit reference with title defaulting to the action
    #  # @see api:Assignments#create
    #  # => <a href="assignments.html#method.assignments_api.create">create</a>
    #
    # @example Inline reference with an overriden title
    #   # Here's a link to absolute {api:Assignments#destroy destruction}
    #   # => <a href="assignments.html#method.assignments_api.destroy">destruction</a>
    #
    # @note Action links inside the All Resources section will be relative.
    if args.first.is_a?(String) && args.first =~ %r{^api:([^#]+)#(.*)}
      topic, controller = *lookup_topic($1.to_s)
      if topic
        html_file = "#{topicize topic.first}.html"
        action = $2
        link_url("#{html_file}#method.#{topicize(controller.name.to_s).sub("_controller", "")}.#{action}", args[1])
      else
        raise "couldn't find API link for #{args.first}"
      end

    # References to API objects defined by @object
    #
    # Syntax: api:ControllerName:Object+Name [TITLE OVERRIDE]
    #
    # @example Explicit resource reference with title defaulting to its name
    #   # @see api:Assignments:Assignment
    #   # => <a href="assignments.html#Assignment">Assignment</a>
    #
    # @example Explicit resource reference with an overriden title
    #   # @return api:Assignments:AssignmentOverride An Assignment Override
    #   # => <a href="assignments.html#Assignment">An Assignment Override</a>
    elsif args.first.is_a?(String) && args.first =~ %r{^api:([^:]+):(.*)}
      scope_name, resource_name = $1.downcase, $2.gsub('+', ' ')
      link_url("#{scope_name}.html##{resource_name}", args[1] || resource_name)
    elsif args.first.is_a?(String) && args.first == 'Appendix:' && args.size > 1
      __errmsg = "unable to locate referenced appendix '#{args[1]}'"

      unless appendix = lookup_appendix(args[1].to_s)
        raise __errmsg
      end

      topic, controller = *lookup_topic(appendix.namespace.to_s)

      if topic
        html_file = "#{topicize topic.first}.html"
        bookmark = "#{appendix.name.to_s.gsub(' ', '+')}-appendix"
        ret = link_url("#{html_file}##{bookmark}", appendix.title)
      else
        raise __errmsg
      end

    # A non-API link, delegate to YARD's HTML linker
    else
      linkify_without_api(*args)
    end
  end

  alias_method :linkify_without_api, :linkify
  alias_method :linkify, :linkify_with_api

  def lookup_topic(controller_name)
    controller = nil
    topic = options[:resources].find do |resource, controllers|
      controllers.detect do |_controller|
        if _controller.path.to_s == controller_name
          controller = _controller
        end
      end
    end

    [ topic, controller ]
  end

  def lookup_appendix(title)
    appendix = nil

    YARD::APIPlugin.log("Looking up appendix: #{title}") if api_options.verbose

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
    controller_name = object.parent.path.underscore
    controller_name.sub!("_controller", '') unless controller_name.include?('/')

    action = object.path.sub(/^.*#/, '').sub(/_with_.*$/, '')

    YARD::Templates::Helpers::RouteHelper.api_methods_for_controller_and_action(controller_name, action)
  end

  def get_current_route
    get_current_routes.first
  end
end
