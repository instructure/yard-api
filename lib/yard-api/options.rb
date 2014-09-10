module YARD::APIPlugin
  class Options < YARD::Options
    default_attr :title, 'Rails API Project'
    default_attr :static, []
    default_attr :files, []
    default_attr :route_namespace, ''

    default_attr :footer_copyright, nil
    default_attr :footer_note, nil

    attr_accessor :readme
  end
end