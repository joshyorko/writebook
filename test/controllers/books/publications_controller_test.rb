require "test_helper"

class Books::PublicationsTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "edit book slug" do
    book = books(:manual)
    book.publish

    get edit_book_publication_url(book)
    assert_response :success

    patch book_publication_url(book), params: { book: { slug: "new-slug" } }
    assert_redirected_to book_publication_url(book)

    assert_equal "new-slug", book.reload.slug
  end
end
