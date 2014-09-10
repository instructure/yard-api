module YARD::APIPlugin
  class Options < YARD::Options
    default_attr :title, 'Rails API Project'
    default_attr :static, []
    default_attr :files, []
    default_attr :route_namespace, ''

    attr_accessor :readme
  end
end