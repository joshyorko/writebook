class DemoContent
  class << self
    def create_manual(user)
      book = Book.create(title: "The Writebook Manual", everyone_access: true)
      book.cover.attach(load_attachement("writebook-manual-cover.png"))
      book.update_access(readers: [], editors: [])

      book.press demo_section, title: "Chapter 1"
      book.press demo_page, title: "My first page"
      book.press demo_picture, title: "Figure 1"
    end

    private
      def demo_section
        Section.new
      end

      def demo_page
        Page.new(body: load_markdown("introduction.md"))
      end

      def demo_picture
        Picture.new(caption: "Inspiration is perishable", image: load_attachement("inspiration-is-perishable.png"))
      end

      def load_attachement(filename, content_type: "image/png")
        {
          io: File.open(Rails.root.join("app/assets/images/demo/#{filename}")),
          filename: filename,
          content_type: content_type
        }
      end

      def load_markdown(filename)
        File.read(Rails.root.join("app/assets/markdown/demo/#{filename}"))
      end
  end
end
