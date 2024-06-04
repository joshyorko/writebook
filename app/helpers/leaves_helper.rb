module LeavesHelper
  def leaf_nav_tag(leaf, **, &)
    tag.nav data: {
      controller: "reading-tracker",
      reading_tracker_book_id_value: leaf.book_id,
      reading_tracker_leaf_id_value: leaf.id
    }, **, &
  end

  def leafable_edit_form(leafable, **, &)
    form_with model: leafable, url: leafable_path(leafable.leaf), method: :put, format: :html,
    data: {
      controller: "autosave",
      action: "autosave#submit input->autosave#change house-md:change->autosave#change",
      autosave_dirty_class: "dirty",
      autosave_saving_class: "saving"
    }, **, &
  end
end
