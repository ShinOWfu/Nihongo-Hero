import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["current"]

  connect() {
    if (this.hasCurrentTarget) {
      setTimeout(() => {
        this.currentTarget.scrollIntoView({ behavior: "smooth", block: "center" })
      }, 50)
    }
  }
}
