require "application_system_test_case"

class EditPageTest < ApplicationSystemTestCase
  setup do
    sign_in "kevin@37signals.com"
  end

  test "edit page" do
    visit edit_book_page_url(books(:handbook), pages(:welcome))
    assert_selector "house-md"

    fill_house_editor "page[body]", with: "Welcome to the handbook! This is the **first** page."

    click_button "Save"

    assert_selector "main", text: "Welcome to the handbook! This is the first page."
    assert_selector "main strong", text: "first"
  end
end
