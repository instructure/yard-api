require 'yard/templates/helpers/html_helper'

module YARD::Templates::Helpers::HtmlHelper
  def topicize(str)
    ::YARD::APIPlugin::Serializer.topicize(str)
  end

  def url_for_file(file, anchor = nil)
    link = file.filename
    link += (anchor ? '#' + urlencode(anchor) : '')
    link
  end

  def visible_static_pages()
    @@visible_static_pages ||= begin
      static_pages.reject { |page| page[:exclude_from_sidebar] }
    end
  end

  def static_pages()
    @@static_pages ||= begin
      locate_static_pages(YARD::APIPlugin.options)
    end
  end

  def locate_static_pages(options)
    title_overrides = {}
    excludes = {}

    paths = Array(options.static).map do |entry|
      pages = if entry.is_a?(Hash)
        if !entry.has_key?('path')
          raise "Static page entry must contain a 'path' parameter: #{entry}"
        elsif !entry.has_key?('title')
          raise "Static page entry must contain a 'title' parameter: #{entry}"
        end

        title_overrides[entry['path']] = entry['title']
        excludes[entry['path']] = true if entry['exclude_from_sidebar']

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

      logger.debug "Serializing static page #{page} (#{title})"

      {
        src: page,
        filename: filename,
        title: title,
        exclude_from_sidebar: !!excludes[page]
      }
    end.sort_by { |page| page[:title] }
  end
  protected :locate_static_pages

  # override yard-appendix link_appendix
  def link_appendix(ref)
    logger.debug "Linking appendix: #{ref}"

    unless appendix = lookup_appendix(ref.to_s)
      YARD::APIPlugin.on_error "Unable to locate referenced appendix '#{ref}'"
      return ref
    end

    html_file = if options[:all_resources] && api_options.one_file
      'index.html'
    elsif options[:all_resources]
      'all_resources.html'
    else
      url_for(appendix.namespace)
    end

    bookmark = "#{appendix.name.to_s.gsub(' ', '+')}-appendix"
    link_url("#{html_file}##{bookmark}", appendix.title).tap do |link|
      logger.debug "\tAppendix link: #{link}"
    end
  end

  def sidebar_link(href, title, is_active)
    link_url(href, title, { class: is_active ? 'active' : '' })
  end

  # Turns text into HTML using +markup+ style formatting.
  #
  # @override Syntax highlighting is not performed on the HTML block.
  #
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

  def htmlify_tag_type(tag)
    co = if tag.type =~ /API::(?:(\S+)::)?(\S+)\b/
      # discard [] at the end denoting array of objects
      P(tag.type.gsub(/\[\]$/, ''))
    end

    if co && !co.is_a?(YARD::CodeObjects::Proxy)
      begin
        linkify(co, tag.type.split(YARD::CodeObjects::NSEP)[1..-1].join(YARD::CodeObjects::NSEP))
      rescue Exception => e
        YARD::APIPlugin.logger.warn e
        ""
      end
    else
      tag.type
    end
  end

  # @override
  #
  # Because we want the endpoints' URLs (an anchor part) to show up as
  # "-endpoint" as opposed to "-instance_method"
  def anchor_for_with_api(object)
    case object
    when YARD::CodeObjects::MethodObject
      "#{object.name}-endpoint"
    else
      anchor_for_without_api(object)
    end
  end
  alias_method :anchor_for_without_api, :anchor_for
  alias_method :anchor_for, :anchor_for_with_api

  def logger
    YARD::APIPlugin.logger
  end
end
