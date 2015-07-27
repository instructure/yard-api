def init
  if options[:controllers]
    sections :layout, [T('topic'), T('appendix')]
  else
    sections :layout, [:contents]
  end
end
