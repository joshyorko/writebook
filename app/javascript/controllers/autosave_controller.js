import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

const AUTOSAVE_INTERVAL = 5000

export default class extends Controller {
  static classes = [ "dirty", "saving" ]

  #timer

  submit(event) {
    event.preventDefault()
    this.#save()
  }

  change() {
    if (!this.#timer) {
      this.#timer = setTimeout(() => this.#save(), AUTOSAVE_INTERVAL)
      this.element.classList.add(this.dirtyClass)
    }
  }

  async #save() {
    this.#resetTimer()

    this.element.classList.add(this.savingClass)
    await this.#submitForm()
    this.element.classList.remove(this.dirtyClass, this.savingClass)
  }

  #resetTimer() {
    clearTimeout(this.#timer)
    this.#timer = null
  }

  async #submitForm() {
    const request = new FetchRequest(this.element.method, this.element.action, {
      body: new FormData(this.element)
    })

    await request.perform()
  }
}
