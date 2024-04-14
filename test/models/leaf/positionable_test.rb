require "test_helper"

class Leaf::PositionableTest < ActiveSupport::TestCase
  setup do
    @leaves = books(:handbook).leaves.positioned
  end

  test "items are sorted in positioned order" do
    assert_equal [ leaves(:welcome_section), leaves(:welcome_page), leaves(:summary_page), leaves(:reading_picture) ], @leaves
  end

  test "items can be moved earlier" do
    leaves(:welcome_page).move_to_position(0)

    assert_equal [ leaves(:welcome_page), leaves(:welcome_section), leaves(:summary_page), leaves(:reading_picture) ], @leaves.reload
  end

  test "items can be moved beyond the start, which puts them at the start" do
    leaves(:welcome_page).move_to_position(-99)

    assert_equal [ leaves(:welcome_page), leaves(:welcome_section), leaves(:summary_page), leaves(:reading_picture) ], @leaves.reload
  end

  test "items can be moved later" do
    leaves(:welcome_section).move_to_position(2)

    assert_equal [ leaves(:welcome_page), leaves(:summary_page), leaves(:welcome_section), leaves(:reading_picture) ], @leaves.reload
  end

  test "items can be moved beyond the end, which puts them at the end" do
    leaves(:welcome_section).move_to_position(99)

    assert_equal [ leaves(:welcome_page), leaves(:summary_page), leaves(:reading_picture), leaves(:welcome_section) ], @leaves.reload
  end

  test "items can be moved to their existing position" do
    leaves(:welcome_page).move_to_position(1)

    assert_equal [ leaves(:welcome_section), leaves(:welcome_page), leaves(:summary_page), leaves(:reading_picture) ], @leaves.reload
  end

  test "items can be moved in blocks" do
    leaves(:welcome_section).move_to_position(1, followed_by: [ leaves(:welcome_page), leaves(:summary_page) ])

    assert_equal [ leaves(:reading_picture), leaves(:welcome_section), leaves(:welcome_page), leaves(:summary_page) ], @leaves.reload
  end

  test "new items are inserted at the end" do
    new_page = books(:handbook).press(Page.new(title: "New Page"))

    assert_equal new_page, books(:handbook).leaves.positioned.last
  end

  test "the first item in the collection has the expected score" do
    books(:handbook).leaves.destroy_all
    new_page = books(:handbook).press(Page.new(title: "New Page"))

    assert_equal 1, new_page.position_score
  end

  test "positioning is rebalanced when necessary" do
    leaves(:welcome_section).update!(position_score: 1e-11)
    leaves(:welcome_page).update!(position_score: 2e-11)

    leaves(:summary_page).move_to_position(1)

    assert_equal leaves(:summary_page), @leaves.reload.second
    assert_equal [ 1, 2, 3, 4 ], @leaves.pluck(:position_score)
  end

  test "items know their neighbours" do
    assert_equal leaves(:welcome_section), leaves(:welcome_page).previous
    assert_equal leaves(:summary_page), leaves(:welcome_page).next

    assert_nil leaves(:welcome_section).previous
    assert_nil leaves(:reading_picture).next
  end
end
