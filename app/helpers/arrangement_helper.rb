module ArrangementHelper
  def arrangement_tag(book, **, &)
    tag.div data: {
      controller: "arrangement",
      arrangement_cursor_class: "arrangement-cursor",
      arrangement_selected_class: "arrangement-selected",
      arrangement_placeholder_class: "arrangement-placeholder",
      arrangement_move_mode_class: "arrangement-move-mode",
      arrangement_url_value: book_leaves_moves_url(book)
    }, **, &
  end

  def arrangement_actions
    actions = {
      "click": "click",
      "dragstart": "dragStart",
      "dragover": "dragOver:prevent",
      "dragend": "dragEnd",
      "drop": "drop",
      "keydown.up": "moveBefore:prevent",
      "keydown.right": "moveAfter:prevent",
      "keydown.down": "moveAfter:prevent",
      "keydown.left": "moveBefore:prevent",
      "keydown.shift+up": "moveBefore:prevent",
      "keydown.shift+right": "moveAfter:prevent",
      "keydown.shift+down": "moveAfter:prevent",
      "keydown.shift+left": "moveBefore:prevent",
      "keydown.space": "toggleMoveMode:prevent",
      "keydown.enter": "applyMoveMode:prevent",
      "keydown.esc": "cancelMoveMode:prevent",
    }

    actions.map { |action, target| "#{action}->arrangement##{target}" }.join(" ")
  end
end
