include T('default/appendix/html')

def init
  super
end

def appendix
  controllers = options[:controllers]

  if options[:all_resources]
    controllers = options[:resources].flatten.select { |o|
      o.is_a?(YARD::CodeObjects::NamespaceObject)
    }
  end

  unless controllers && controllers.is_a?(Array)
    return
  end

  @appendixes = controllers.collect do |controller|
    controller.children.select { |tag| :appendix == tag.type }
  end.flatten.uniq

  super
end