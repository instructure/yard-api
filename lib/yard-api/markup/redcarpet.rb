require 'redcarpet'
require 'yard/templates/helpers/markup_helper'

module YARD::APIPlugin::Markup
  # TODO: make this configurable
  class RedcarpetDelegate
    Extensions = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      autolink: true,
      tables: true,
      lax_spacing: false,
      space_after_headers: true,
      underline: true,
      highlight: true,
      footnotes: true
    }.freeze

    RendererOptions = {
    }.freeze

    def initialize(text, extensions_and_options=nil)
      @renderer = Redcarpet::Render::HTML.new(RendererOptions)
      @markdown = Redcarpet::Markdown.new(@renderer, Extensions)
      @text = text
    end

    def to_html
      @markdown.render(@text)
    end
  end
end

module YARD::Templates::Helpers
  if MarkupHelper.markup_cache.nil?
    MarkupHelper.clear_markup_cache
  end

  MarkupHelper.markup_cache[:markdown] ||= {}
  MarkupHelper.markup_cache[:markdown][:class] = YARD::APIPlugin::Markup::RedcarpetDelegate
end

