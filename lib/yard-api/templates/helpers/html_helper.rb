require 'yard/templates/helpers/html_helper'

module YARD::Templates::Helpers::HtmlHelper
  def topicize(str)
    str.gsub(' ', '_').underscore
  end

  def url_for_file(filename, anchor = nil)
    link = filename.filename
    link += (anchor ? '#' + urlencode(anchor) : '')
    link
  end

  def static_pages()
    options = YARD::APIPlugin.options

    paths = Array(options.static).map do |entry|
      pages = if entry.is_a?(Hash)
        glob = entry['glob']
        blacklist = Array(entry['exclude'])

        unless glob
          raise "Invalid static page entry, expected Hash to contain a 'glob' parameter: #{entry}"
        end

        pages = Dir.glob(entry['glob'])

        if blacklist.any?
          pages.delete_if { |p| blacklist.any? { |filter| p.match(filter) } }
        end

        pages
      elsif entry.is_a?(Array)
        entry.map(&:to_s)
      elsif entry.is_a?(String)
        [ entry ]
      end
    end.flatten.compact

    markdown_exts = YARD::Templates::Helpers::MarkupHelper::MARKUP_EXTENSIONS[:markdown]
    readme_page = options.readme
    pages = Dir.glob(paths)

    if readme_page.present?
      pages.delete_if { |page| page.match(readme_page) }
    end

    pages.map do |page|
      filename = 'file.' + File.split(page).last.sub(/\..*$/, '.html')

      # extract page title if it's a markdown document; title is expected to
      # be an h1 on the very first line:
      title = if markdown_exts.include?(File.extname(page).sub('.', ''))
        (File.open(page, &:gets) || '').strip.sub('# ', '')
      else
        # otherwise we'll just sanitize the file name
        File.basename(page).sub(/\.\w+$/, '').gsub(/\W/, ' ').gsub(/\s+/, ' ').capitalize
      end

      {
        src: page,
        filename: filename,
        title: title
      }
    end
  end

  # override yard-appendix link_appendix
  def link_appendix(ref)
    __errmsg = "unable to locate referenced appendix '#{ref}'"

    puts "looking up appendix: #{ref}"
    unless appendix = lookup_appendix(ref.to_s)
      raise __errmsg
    end

    topic, controller = *lookup_topic(appendix.namespace.to_s)

    unless topic
      raise __errmsg
    end

    html_file = "#{topicize topic.first}.html"
    bookmark = "#{appendix.name.to_s.gsub(' ', '+')}-appendix"
    link_url("#{html_file}##{bookmark}", appendix.title)
  end
end
