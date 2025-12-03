import { Controller } from "@hotwired/stimulus"
import confetti from "confetti"

export default class extends Controller {
    static targets = ["level", "progressBar"]
    static values = {newExp: Number, oldExp: Number, levelUp: Boolean}

  connect() {
    window.addEventListener("results:complete", () => this.start(), { once: true })
  }

  start() {
  if (this.levelUpValue) {
    // --- First fill up to 100% to show level up ---
    const newLevel = parseInt(this.levelTarget.innerText)
    this.levelTarget.innerText = newLevel - 1
    this.progressBarTarget.style.width = '100%';
    setTimeout(()=>{
      this.progressBarTarget.classList.remove("progress-bar")
            this.progressBarTarget.style.width = '0%';
    },2000)

    setTimeout(()=>{
      this.levelTarget.innerText = newLevel
      this.levelTarget.style.color = "gold"
      confetti()
      this.progressBarTarget.classList.add("progress-bar")
      this.progressBarTarget.style.width = `${this.newExpValue}%`;
    },2050)

  } else {
    // --- Level Up is not true (Standard experience gain) ---
    this.progressBarTarget.style.width = `${this.newExpValue}%`;
  }
  }
}
