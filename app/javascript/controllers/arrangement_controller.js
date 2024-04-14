import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

const Direction = {
  BEFORE: -1,
  AFTER: 1
}

const ITEM_SELECTOR = "[data-arrangement-target=item]"

export default class extends Controller {
  static targets = [ "container", "item", "layer", "dragImage" ]
  static classes = [ "cursor", "selected", "placeholder", "moveMode" ]
  static values = { url: String }

  #cursorPosition
  #dragItem
  #wasDropped
  #originalOrder
  #selection
  #moveMode = false


  // Actions - selection state

  click(event) {
    const target = event.target.closest(ITEM_SELECTOR)
    this.#setSelection(target, event.shiftKey)
  }

  setArrangeMode(event) {
    for (const item of this.itemTargets) {
      item.setAttribute("draggable", event.target.checked)
    }
    this.#resetSelection()
  }


  // Actions - keyboard

  moveBefore(event) {
    if (this.#moveMode) {
      this.#moveSelection(Direction.BEFORE)
    } else {
      const newPosition = this.#cursorPosition === undefined ? this.itemTargets.length - 1 : Math.max(this.#cursorPosition - 1, 0)
      this.#setCursor(newPosition, event.shiftKey)
    }
  }

  moveAfter(event) {
    if (this.#moveMode) {
      this.#moveSelection(Direction.AFTER)
    } else {
      const newPosition = this.#cursorPosition === undefined ? 0 : Math.min(this.#cursorPosition + 1, this.itemTargets.length - 1)
      this.#setCursor(newPosition, event.shiftKey)
    }
  }

  toggleMoveMode() {
    if (this.#moveMode) {
      this.applyMoveMode()
    } else {
      this.#moveMode = true
      this.#originalOrder = [ ...this.itemTargets ]
    }

    this.#renderSelection()
  }

  applyMoveMode() {
    this.#moveMode = false
    this.#originalOrder = undefined
    this.#renderSelection()
    this.#submitMove()
  }

  cancelMoveMode() {
    if (this.#moveMode) {
      this.containerTarget.append(...this.#originalOrder)
      this.#moveMode = false
      this.#originalOrder = undefined
    }

    this.#resetSelection()
  }


  // Actions - drag & drop

  dragStart(event) {
    this.#wasDropped = false
    this.#dragItem = event.target
    this.#originalOrder = [ ...this.itemTargets ]

    if (!this.#targetIsSelected(event.target)) {
      this.#setSelection(event.target, false)
    }

    if (this.#selectionSize > 1) {
      this.dragImageTarget.textContent = `${this.#selectionSize} items`
      event.dataTransfer.setDragImage(this.dragImageTarget, 0, 0)
    }

    this.#buildLayer()

    setTimeout(() => {
      this.containerTarget.style.opacity = "0"
    }, 0)
  }

  drop() {
    this.#wasDropped = true
    this.#submitMove()
  }

  dragEnd() {
    if (!this.#wasDropped) {
      this.containerTarget.append(...this.#originalOrder)
      this.#selection = undefined
      this.#renderSelection()
      this.#originalOrder = undefined
    }

    this.containerTarget.style.opacity = "1"
    this.#clearLayer()
  }

  dragOver(event) {
    if (event.target.tagName == "LI" && !this.#targetIsSelected(event.target)) {
      const offset = this.itemTargets.indexOf(this.#dragItem) - this.itemTargets.indexOf(event.target)
      const isBefore = offset < 0
      const rect = event.target.getBoundingClientRect()
      const mid = rect.top + rect.height / 2.0

      if (event.clientY < mid && !isBefore) {
        this.#keepingSelection(() => {
          event.target.before(...this.#selectedItems)
        })
        this.#updateLayer()
        this.#renderSelection()
      }

      if (event.clientY > mid && isBefore) {
        this.#keepingSelection(() => {
          event.target.after(...this.#selectedItems)
        })
        this.#updateLayer()
        this.#renderSelection()
      }
    }
  }


  // Internal

  #setCursor(index, expandSelection) {
    this.#cursorPosition = index
    this.itemTargets[this.#cursorPosition].scrollIntoView({ block: 'nearest', inline: 'nearest' })
    this.#setSelection(this.itemTargets[index], expandSelection)
  }

  #setSelection(target, expandSelection) {
    const idx = this.itemTargets.indexOf(target)

    if (expandSelection && this.#selection) {
      this.#selection = [
        Math.min(idx, this.#selectionStart),
        Math.max(idx, this.#selectionEnd),
      ]
    } else {
      this.#selection = [ idx, idx ]
    }

    this.#renderSelection()
  }

  #renderSelection() {
    for (const [ index, item ] of this.itemTargets.entries()) {
      item.classList.toggle(this.selectedClass, index >= this.#selectionStart && index <= this.#selectionEnd)
      item.classList.toggle(this.cursorClass, index === this.#cursorPosition)
    }
    this.containerTarget.classList.toggle(this.moveModeClass, this.#moveMode)
  }

  #moveSelection(direction) {
    this.#keepingSelection(() => {
      if (direction === Direction.BEFORE && this.#selectionStart > 0) {
        this.itemTargets[this.#selectionEnd].after(this.itemTargets[this.#selectionStart - 1])
        this.#cursorPosition--
      }
      if (direction === Direction.AFTER && this.#selectionEnd < this.itemTargets.length - 1) {
        this.itemTargets[this.#selectionStart].before(this.itemTargets[this.#selectionEnd + 1])
        this.#cursorPosition++
      }
    })
    this.#renderSelection()
  }

  #buildLayer() {
    for (const [ index, item ] of this.itemTargets.entries()) {
      const selected = index >= this.#selectionStart && index <= this.#selectionEnd
      const clone = selected ? this.#makePlaceholder() : item.cloneNode(true)

      clone.style.position = "absolute"
      clone.style.pointerEvents = "none"
      clone.style.transition = "top 160ms, left 160ms"

      const newRect = this.#getElementRect(item)
      this.#setElementRect(clone, newRect)

      this.layerTarget.append(clone)
      item.clone = clone
    }
  }

  #updateLayer() {
    for (const item of this.itemTargets) {
      if (item.clone) {
        const newRect = this.#getElementRect(item)
        newRect.x += 400
        this.#setElementRect(item.clone, newRect)
      }
    }
  }

  #clearLayer() {
    this.layerTarget.innerHTML = ""
  }

  #getElementRect(element) {
    const rect = element.getBoundingClientRect()
    const parent = element.closest(".position-relative").getBoundingClientRect()

    return {
        top: rect.top - parent.top,
        left: rect.left - parent.left,
        bottom: rect.bottom - parent.bottom,
        right: rect.right - parent.right,
        width: rect.width,
        height: rect.height
    };
  }

  #setElementRect(element, rect) {
    element.style.position = 'absolute'
    element.style.left = `${rect.left}px`
    element.style.top = `${rect.top}px`
    element.style.width = `${rect.width}px`
    element.style.height = `${rect.height}px`
  }

  #makePlaceholder() {
    const node = document.createElement("div")
    node.classList.add(this.placeholderClass)
    return node
  }

  #targetIsSelected(target) {
    const idx = this.itemTargets.indexOf(target)
    return idx >= this.#selectionStart && idx <= this.#selectionEnd
  }

  #keepingSelection(fn) {
    const first = this.itemTargets[this.#selectionStart]
    const last = this.itemTargets[this.#selectionEnd]
    fn()
    this.#selection = [ this.itemTargets.indexOf(first), this.itemTargets.indexOf(last) ]
  }

  #resetSelection() {
    this.#selection = undefined
    this.#cursorPosition = undefined
    this.#renderSelection()
  }

  #submitMove() {
    const position = this.#selection[0]
    const ids = this.itemTargets
      .slice(this.#selection[0], this.#selection[1] + 1)
      .map((item) => item.dataset.id)

    const body = new FormData()
    body.append("position", position)
    ids.forEach((id) => body.append("id[]", id))

    post(this.urlValue, { body })
  }

  get #selectionStart() {
    if (this.#selection) {
      return this.#selection[0]
    }
  }

  get #selectionEnd() {
    if (this.#selection) {
      return this.#selection[1]
    }
  }

  get #selectionSize() {
    if (this.#selection) {
      return this.#selectionEnd - this.#selectionStart + 1
    }
    return 0
  }

  get #selectedItems() {
    return this.itemTargets.slice(this.#selectionStart, this.#selectionEnd + 1)
  }
}
