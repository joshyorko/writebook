require "test_helper"

class Book::DemoContentTest < ActiveSupport::TestCase
  test "new books have demo content when created" do
    skip "Until we decide if we're keeping this feature."
    book = Book.create! title: "New Book"

    assert book.leaves.pages.count == 1
    assert book.leaves.pictures.count == 1
    assert book.leaves.sections.count == 1
  end
end
