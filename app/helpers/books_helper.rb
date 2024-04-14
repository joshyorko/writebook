module BooksHelper
  def book_toc_tag(book, &)
    tag.ol class: "toc", tabindex: 0,
      data: {
        controller: "arrangement",
        action: arrangement_actions,
        arrangement_cursor_class: "arrangement-cursor",
        arrangement_selected_class: "arrangement-selected",
        arrangement_placeholder_class: "arrangement-placeholder",
        arrangement_move_mode_class: "arrangement-move-mode",
        arrangement_url_value: book_leaves_moves_url(book)
      }, &
  end

  def link_to_previous_leafable(leaf)
    if previous_leaf = leaf.previous
      link_to leafable_path(previous_leaf), data: { **hotkey_data_attributes("left") }, class: "txt-ink txt-undecorated flex align-center gap full-width flex-item-grow min-width justify-start flex-item-justify-start" do
        tag.span(class: "btn") do
          image_tag("arrow-left.svg", aria: { hidden: true }, size: 24) + tag.span("Previous", class: "for-screen-reader")
        end + tag.span(previous_leaf.title, class: "overflow-ellipsis")
      end
    end
  end

  def link_to_next_leafable(leaf)
    if next_leaf = leaf.next
      link_to leafable_path(next_leaf), data: { **hotkey_data_attributes("right") }, class: "txt-ink txt-undecorated flex align-center gap full-width flex-item-grow min-width justify-end flex-item-justify-end" do
        tag.span(next_leaf.title, class: "overflow-ellipsis") +
        tag.span(class: "btn") do
          image_tag("arrow-right.svg", aria: { hidden: true }, size: 24) + tag.span("Next", class: "for-screen-reader")
        end
      end
    end
  end

  private
    def hotkey_data_attributes(key)
      { controller: "hotkey", action: "keydown.#{key}@document->hotkey#click" }
    end
end
