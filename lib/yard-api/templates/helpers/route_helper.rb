module YARD::Templates::Helpers
  module RouteHelper
    def self.routes_for(prefix)
      Rails.application.routes.set
    end

    def self.matches_controller_and_action?(route, controller, action)
      route.requirements[:controller] == controller &&
      route.requirements[:action] == action
    end

    def self.api_methods_for_controller_and_action(controller, action)
      @routes ||= self.routes_for('/')
      controller_path = [ YARD::APIPlugin.options.route_namespace, controller ].join('/')
      controller_path.gsub!(/^\/|_controller$/, '')
      @routes.find_all { |r| matches_controller_and_action?(r, controller_path, action) }
    end
  end
end