require "rouge/plugins/redcarpet"

class RendererWithSyntaxHighlighting < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def self.build_with_defaults
    renderer = RendererWithSyntaxHighlighting.new(ActionText::Markdown::DEFAULT_RENDERER_OPTIONS)
    Redcarpet::Markdown.new(renderer, ActionText::Markdown::DEFAULT_MARKDOWN_EXTENSIONS)
  end
end
