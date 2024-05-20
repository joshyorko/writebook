import { Controller } from "@hotwired/stimulus"
import { readCookie } from "helpers/cookie_helpers"

export default class extends Controller {
  static values = { bookId: Number }
  static classes = [ "lastRead" ]

  connect() {
    this.#markLastReadLeaf()
  }

  #markLastReadLeaf() {
    const readingProgress = readCookie(`reading_progress_${this.bookIdValue}`)

    if (readingProgress) {
      const [ leafId ] = readingProgress.split("/")
      const leafElement = leafId && this.element.querySelector(`#leaf_${leafId}`)

      if (leafElement) {
        leafElement.classList.add(this.lastReadClass)
      }
    }
  }
}
