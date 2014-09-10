require 'rails'

module YARD::APIPlugin
  class Railtie < ::Rails::Railtie
    railtie_name :yard_api

    rake_tasks do
      load File.join(YARD::APIPlugin::TASK_PATH, 'yard_api.rake')
    end
  end
end