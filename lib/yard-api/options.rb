module YARD::APIPlugin
  class Options < YARD::Options
    default_attr :title, 'Rails API Project'
    default_attr :source, 'doc/api'
    default_attr :static, []
    default_attr :files, []
    default_attr :route_namespace, ''

    default_attr :footer_copyright, nil
    default_attr :footer_note, nil

    default_attr :one_file, false
    default_attr :verbose, false
    default_attr :debug, false
    default_attr :theme, 'default'

    attr_accessor :readme
  end
end