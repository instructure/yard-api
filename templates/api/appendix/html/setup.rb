include T('default/appendix/html')

def init
  super
end

def appendix
  controllers = options[:controllers]

  unless controllers && controllers.is_a?(Array)
    return
  end

  @appendixes = controllers.collect { |c|
    c.children.select { |o| :appendix == o.type }
  }.flatten

  super
end