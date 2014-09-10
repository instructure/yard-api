# yard-api-plugin - a YARD plugin for generating API documentation in Rails.
# Copyright (C) 2014 Ahmad Amireh <ahmad@instructure.com>
# Copyright (C) 2011 Instructure, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# require 'route_helper'
module RouteHelper
  def self.routes_for(prefix)
    Rails.application.routes.set
  end

  def self.matches_controller_and_action?(route, controller, action)
    route.requirements[:controller] == controller && route.requirements[:action] == action
  end

  def self.api_methods_for_controller_and_action(controller, action)
    @routes ||= self.routes_for('/')
    @routes.find_all { |r| matches_controller_and_action?(r, controller, action) }
  end
end

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
end
