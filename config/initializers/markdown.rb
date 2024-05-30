ActiveSupport.on_load(:action_text_markdown) do
  require "renderer_with_syntax_highlighting"
  ActionText::Markdown.renderer = RendererWithSyntaxHighlighting.build_with_defaults
end
