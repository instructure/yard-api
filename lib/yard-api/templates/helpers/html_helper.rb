require 'yard/templates/helpers/html_helper'

module YARD::Templates::Helpers::HtmlHelper
  def topicize(str)
    str.split("\n")[0].gsub(' ', '_').underscore
  end

  def url_for_file(filename, anchor = nil)
    link = filename.filename
    link += (anchor ? '#' + urlencode(anchor) : '')
    link
  end

  def static_pages()
    @@static_pages ||= begin
      locate_static_pages(YARD::APIPlugin.options)
    end
  end

  def locate_static_pages(options)
    title_overrides = {}

    paths = Array(options.static).map do |entry|
      pages = if entry.is_a?(Hash)
        if !entry.has_key?('path')
          raise "Static page entry must contain a 'path' parameter: #{entry}"
        elsif !entry.has_key?('title')
          raise "Static page entry must contain a 'title' parameter: #{entry}"
        end

        title_overrides[entry['path']] = entry['title']

        entry['path']
      elsif entry.is_a?(Array)
        entry.map(&:to_s)
      elsif entry.is_a?(String)
        entry
      end
    end

    pages = Dir.glob(paths.flatten.compact)

    if options.readme && !options.one_file
      pages.delete_if { |page| page.match(options.readme) }
    end

    pages.uniq.map do |page|
      filename = 'file.' + File.split(page).last.sub(/\..*$/, '.html')

      title = (
        title_overrides[page] ||
        File.basename(page)
          .sub(/\.\w+$/, '')
          .gsub('_', ' ')
          .gsub(/\W/, ' ')
          .gsub(/\s+/, ' ')
          .capitalize
      )

      if options.verbose
        puts "Serializing static page #{page} (#{title})"
      end

      {
        src: page,
        filename: filename,
        title: title
      }
    end.sort_by { |page| page[:title] }
  end
  protected :locate_static_pages

  # override yard-appendix link_appendix
  def link_appendix(ref)
    puts "Linking appendix: #{ref}" if api_options.verbose

    unless appendix = lookup_appendix(ref.to_s)
      raise "Unable to locate referenced appendix '#{ref}'"
    end

    html_file = if options[:all_resources] && api_options.one_file
      'index.html'
    elsif options[:all_resources]
      'all_resources.html'
    else
      topic, controller = *lookup_topic(appendix.namespace.to_s)

      unless topic
        raise "Unable to locate topic for appendix: #{ref}"
      end

      "#{topicize(topic.first)}.html"
    end

    bookmark = "#{appendix.name.to_s.gsub(' ', '+')}-appendix"
    link_url("#{html_file}##{bookmark}", appendix.title).tap do |link|
      puts "\tAppendix link: #{link}" if api_options.verbose
    end
  end

  def sidebar_link(title, href, options={})
    options[:class_name] ||= (object == href ? 'active' : nil)

    <<-HTML
      <a href="#{url_for(href)}" class="#{options[:class_name]}">#{title}</a>
    HTML
  end

  # Turns text into HTML using +markup+ style formatting.
  #
  # @override Syntax highlighting is not performed on the HTML block.
  # @param [String] text the text to format
  # @param [Symbol] markup examples are +:markdown+, +:textile+, +:rdoc+.
  #   To add a custom markup type, see {MarkupHelper}
  # @return [String] the HTML
  def htmlify(text, markup = options.markup)
    markup_meth = "html_markup_#{markup}"
    return text unless respond_to?(markup_meth)
    return "" unless text
    return text unless markup
    html = send(markup_meth, text)
    if html.respond_to?(:encode)
      html = html.force_encoding(text.encoding) # for libs that mess with encoding
      html = html.encode(:invalid => :replace, :replace => '?')
    end
    html = resolve_links(html)
    html
  end
end
