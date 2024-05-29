require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "press a leafable" do
    leaf = books(:manual).press Page.new(body: "Important words"), title: "Introduction"
    assert leaf.page?
  end
end
