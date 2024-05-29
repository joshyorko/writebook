require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "create" do
    post book_pages_path(books(:handbook)), params: { leaf: { title: "Another page" }, page: { body: "With interesting words." } }
    assert_redirected_to books(:handbook)

    new_page = Page.last
    assert_equal "Another page", new_page.title
    assert_equal "With interesting words.", new_page.body.content
    assert_equal books(:handbook), new_page.leaf.book
  end

  test "create with default params" do
    assert_changes -> { Page.count }, +1 do
      post book_pages_path(books(:handbook))
    end
    assert_redirected_to books(:handbook)

    assert_equal "Untitled", Page.last.title
  end

  test "create at a specific position" do
    assert_changes -> { Page.count }, +1 do
      post book_pages_path(books(:handbook), params: { position: 2 })
    end
    assert_redirected_to books(:handbook)

    assert_equal 2, books(:handbook).leaves.before(Page.last.leaf).count
  end

  test "update" do
    get edit_leafable_path(leaves(:welcome_page))
    assert_response :ok

    put leafable_path(leaves(:welcome_page)), params: { leaf: { title: "Better welcome" }, page: { body: "With even more interesting words." } }
    assert_redirected_to leafable_path(leaves(:welcome_page).reload)

    updated_page = Page.last
    assert_equal "Better welcome", updated_page.title
    assert_equal "With even more interesting words.", updated_page.body.content
  end
end
