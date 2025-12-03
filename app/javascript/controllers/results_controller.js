import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["circle", "percentage", "rank", "playerSprite"]
  static values = { percentage: Number, victory: Boolean }

  connect() {
    setTimeout(() => this.animateCircle(), 300)
  }

  animateCircle() {
    const circumference = 2 * Math.PI * 54
    const targetPercentage = this.percentageValue
    const duration = 1200
    const startTime = performance.now()

    this.circleTarget.style.strokeDasharray = circumference
    this.circleTarget.style.strokeDashoffset = circumference
    this.percentageTarget.textContent = "0%"

    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      const easeOut = 1 - Math.pow(1 - progress, 3)

      const currentPercentage = Math.round(easeOut * targetPercentage)
      const offset = circumference * (1 - (easeOut * targetPercentage / 100))

      this.circleTarget.style.strokeDashoffset = offset
      this.percentageTarget.textContent = `${currentPercentage}%`

      if (progress < 1) {
        requestAnimationFrame(animate)
      } else {
        this.revealRank()
      }
    }

    requestAnimationFrame(animate)
  }

    revealRank() {
    this.percentageTarget.style.transition = "opacity 0.1s"

    this.rankTarget.classList.add("rank-visible")

    if (this.victoryValue && this.hasPlayerSpriteTarget) {
      this.playerSpriteTarget.classList.add("celebrating")
    }

    setTimeout(() => {
    window.dispatchEvent(new CustomEvent("results:complete"))
    }, 500)
  }
}
