def init
  puts "> LAYOUT"
  # puts options[:object]

  if options[:controllers]
    sections :layout, [T('topic'), T('appendix')]
  else
    sections :layout, [:contents]
  end
end
