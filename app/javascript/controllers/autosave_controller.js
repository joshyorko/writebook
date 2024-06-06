import { Controller } from "@hotwired/stimulus"
import { submitForm } from "helpers/form_helpers"

const AUTOSAVE_INTERVAL = 3000

export default class extends Controller {
  static classes = [ "dirty", "saving" ]

  #timer

  submit() {
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
    await submitForm(this.element)
    this.element.classList.remove(this.dirtyClass, this.savingClass)
  }

  #resetTimer() {
    clearTimeout(this.#timer)
    this.#timer = null
  }
}

