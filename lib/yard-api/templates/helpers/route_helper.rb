module YARD::Templates::Helpers
  module RouteHelper
    class << self
      def routes_for(prefix)
        Rails.application.routes.set
      end

      def routes_for_yard_object(api_object)
        controller_name = api_object.parent.path.underscore
        controller_name.sub!('_controller', '') unless controller_name.include?('/')

        action = api_object.path.sub(/^.*#/, '').sub(/_with_.*$/, '')

        api_methods_for_controller_and_action(controller_name, action)
      end

      def matches_controller_and_action?(route, controller, action)
        route.requirements[:controller] == controller &&
        route.requirements[:action] == action
      end

      def api_methods_for_controller_and_action(controller, action)
        @routes ||= routes_for('/')
        controller_path = [ YARD::APIPlugin.options.route_namespace, controller ].join('/')
        controller_path.gsub!(/^\/|_controller$/, '')
        @routes.find_all { |r| matches_controller_and_action?(r, controller_path, action) }
      end

      def get_route_path(route)
        route.path.spec.to_s.gsub("(.:format)", "")
      end

      def get_route_verb(route)
        verb = route.verb

        case verb
        when Regexp
          verb.source =~ /\^?(\w*)\$/ ? $1.upcase : verb.source
        when String
          verb
        else
          "???"
        end
      end
    end
  end
end
