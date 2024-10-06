module SearchesHelper
  def highlighted_match(match)
    sanitize match, tags: %w[ mark ]
  end

  def search_button(book)
    render "books/searches/search", book: book
  end
end
