module EditsHelper
  def edit_action_name(edit)
    case edit.action
    when "creation" then "Created"
    when "revision" then "Revised"
    when "trash" then "Trashed"
    end
  end
end
