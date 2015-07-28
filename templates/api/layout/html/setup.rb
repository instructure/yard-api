include Helpers::FilterHelper

def init
  @page_title = options[:title]

  if options[:inline_file]
    @contents = File.read(options[:file])
    sections :diskfile
  elsif @file
    sections :layout, [:diskfile]
  elsif options[:all_resources]
    sections :layout, [T('topic'), T('appendix')]
  elsif options[:controllers]
    sections :layout, [T('topic'), T('appendix')]
  else
    sections :layout, [:contents]
  end
end

def stylesheets
  %w[
    css/common.css
    css/highlight.css
  ]
end

def inline_stylesheets
  [ '_dynamic_styles' ]
end

def javascripts
  %w[
    js/jquery-1.11.1.min.js
    js/highlight/highlight.pack.js
    js/app.js
  ]
end

def inline_javascripts
  []
end

def contents
  @contents
end

def index
  legitimate_objects = @objects.reject do |object|
    object.root? ||
    !is_class?(object) ||
    !object.meths.find { |m| !m.tags('API').empty? }
  end

  @resources = legitimate_objects.sort_by do |object|
    object.tags('API').first.text
  end

  erb(:index)
end

def diskfile(filename=@file)
  if filename.is_a?(String)
    @contents = File.read(filename)
    filename = File.basename(filename)
  elsif filename.is_a?(File)
    @contents = filename.contents
    filename = File.basename(filename.path)
  end

  extension = (File.extname(filename)[1..-1] || '').downcase

  content = "<div id='filecontents'>" +
  case extension
  when 'htm', 'html'
    @contents
  when 'txt'
    "<pre>#{@contents}</pre>"
  when 'textile', 'txtile'
    htmlify(@contents, :textile)
  when 'markdown', 'md', 'mdown', 'mkd'
    htmlify(@contents, :markdown)
  else
    htmlify(@contents, diskfile_shebang_or_default)
  end +
  "</div>"
  options.delete(:no_highlight)
  content
end

def diskfile_shebang_or_default
  if @contents =~ /\A#!(\S+)\s*$/ # Shebang support
    @contents = $'
    $1.to_sym
  else
    options[:markup]
  end
end
