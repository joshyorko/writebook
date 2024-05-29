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

  def book_part_create_button(book, kind, **, &)
    url = url_for [ book, kind.new ]

    button_to url, class: "btn btn--plain txt-medium fill-transparent disable-when-arranging", draggable: true,
      data: {
        action: "dragstart->arrangement#dragStartCreate dragend->arrangement#dragEndCreate",
        arrangement_url_param: url
      }, **, &
  end

  def link_to_first_leafable(leaves)
    if first_leaf = leaves.first
      link_to leafable_path(first_leaf), data: { **hotkey_data_attributes("right") }, class: "txt-ink txt-undecorated flex align-center gap full-width flex-item-grow min-width justify-start flex-item-justify-start", hidden: true do
        tag.span(class: "btn") do
          image_tag("arrow-right.svg", aria: { hidden: true }, size: 24) + tag.span("Start reading", class: "for-screen-reader")
        end + tag.span(first_leaf.title, class: "overflow-ellipsis")
      end
    end
  end

  def link_to_previous_leafable(leaf)
    if previous_leaf = leaf.previous
      link_to leaf.book.editable? ? edit_leafable_path(previous_leaf) : leafable_path(previous_leaf), data: { **hotkey_data_attributes("left") }, class: "btn flex-item-justify-start" do
        image_tag("arrow-left.svg", aria: { hidden: true }, size: 24) + tag.span(previous_leaf.title, class: "for-screen-reader")
      end
    else
      link_to Current.user ? book_path(leaf.book) : public_book_path(leaf.book.slug), data: { **hotkey_data_attributes("left") }, class: "btn flex-item-justify-start" do
        image_tag("arrow-left.svg", aria: { hidden: true }, size: 24) + tag.span("Table of contents", class: "for-screen-reader")
      end
    end
  end

  def link_to_next_leafable(leaf)
    if next_leaf = leaf.next
      link_to leaf.book.editable? ? edit_leafable_path(next_leaf) : leafable_path(next_leaf), data: { **hotkey_data_attributes("right") }, class: "txt-ink txt-medium txt-undecorated flex align-center gap full-width flex-item-grow min-width justify-end flex-item-justify-end" do
        tag.span(next_leaf.title, class: "overflow-ellipsis") +
        tag.span(class: "btn txt-medium") do
          image_tag("arrow-right.svg", aria: { hidden: true }, size: 24) + tag.span("Next", class: "for-screen-reader")
        end
      end
    else
      link_to Current.user ? book_path(leaf.book) : public_book_path(leaf.book.slug), data: { **hotkey_data_attributes("right") }, class: "txt-ink txt-medium txt-undecorated flex align-center gap full-width flex-item-grow min-width justify-end flex-item-justify-end" do
        tag.span("End", class: "overflow-ellipsis") +
        tag.span(class: "btn txt-medium") do
          image_tag("arrow-right.svg", aria: { hidden: true }, size: 24) + tag.span("End", class: "for-screen-reader")
        end
      end
    end
  end

  private
    def hotkey_data_attributes(key)
      { controller: "hotkey", action: "keydown.#{key}@document->hotkey#click" }
    end
end
