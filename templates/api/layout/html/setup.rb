include Helpers::FilterHelper

def init
  @breadcrumb = []

  @page_title = options[:title]

  if @file
    if @file.is_a?(String)
      @contents = File.read(@file)
      @file = File.basename(@file)
    else
      @contents = @file.contents
      @file = File.basename(@file.path)
    end
    def @object.source_type; nil; end
    sections :layout, [:diskfile]
  elsif options[:controllers]
    sections :layout, [T('topic'), T('appendix')]
  else
    sections :layout, [:contents]
  end
end

def contents
  @contents
end

def index
  legitimate_objects = @objects.reject {|o| o.root? || !is_class?(o) || !o.meths.find { |m| !m.tags('API').empty? } }

  @resources = legitimate_objects.sort_by {|o| o.tags('API').first.text }

  erb(:index)
end

def diskfile
  content = "<div id='filecontents'>" +
  case (File.extname(@file)[1..-1] || '').downcase
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
