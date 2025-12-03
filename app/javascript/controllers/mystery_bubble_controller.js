import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bubble"]

  show(event) {
    event.preventDefault()

    this.bubbleTarget.classList.add("mystery-bubble--visible")

    setTimeout(() => {
      this.bubbleTarget.classList.remove("mystery-bubble--visible")
    }, 1500)
  }
}
