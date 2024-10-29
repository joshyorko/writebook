module SearchesHelper
  def highlight_page_body(page, query)
    if query.present?
      terms = page.leaf.matches_for_highlight(query)
      terms = whole_word_matchers(terms)
      sanitize_content highlight(page.body.to_html, terms, sanitize: false)
    else
      sanitize_content page.body.to_html
    end
  end

  private
    def whole_word_matchers(terms)
      terms.map { |term| /\b#{term}\b/ }
    end
end
