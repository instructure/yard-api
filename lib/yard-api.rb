# yard-api-plugin - a YARD plugin for generating API documentation in Rails.
#
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

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'yard'
require 'yard-appendix'

module YARD
  module APIPlugin
    ROOT          = File.dirname(__FILE__)
    CONFIG_PATH   = File.join(%W[#{ROOT} .. config])
    TEMPLATE_PATH = File.join(%W[#{ROOT} .. templates])
    TASK_PATH     = File.join(%W[#{ROOT} .. tasks])

    def self.options
      @@options ||= Options.new
    end
  end

  require 'yard-api/version'
  require 'yard-api/options'
  require 'yard-api/tags'
  require 'yard-api/verifier'
  require 'yard-api/templates/helpers/base_helper'
  require 'yard-api/templates/helpers/html_helper'
  require 'yard-api/templates/helpers/route_helper'
  require 'yard-api/railtie' if defined?(Rails)

  module Templates
    Engine.register_template_path YARD::APIPlugin::TEMPLATE_PATH
  end
end
