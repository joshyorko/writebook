module ActionText
  class Markdown < Record
    DEFAULT_RENDERER_OPTIONS = {
      filter_html: true
    }

    DEFAULT_MARKDOWN_EXTENSIONS = {
      autolink: true,
      hightlight: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      strikethrough: true,
      tables: true
    }

    mattr_accessor :renderer, default: Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(DEFAULT_RENDERER_OPTIONS), DEFAULT_MARKDOWN_EXTENSIONS)

    belongs_to :record, polymorphic: true, touch: true

    def to_html
      renderer.render(content).html_safe
    end
  end
end

module ActionText::Markdown::Uploads
  extend ActiveSupport::Concern

  included do
    has_many_attached :uploads, dependent: :destroy
  end
end

ActiveSupport.on_load :active_storage do
  class ActionText::Markdown
    include ActionText::Markdown::Uploads
  end
end

ActiveSupport.run_load_hooks :action_text_markdown, ActionText::Markdown
