import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["circle", "percentage", "rank", "playerSprite"]
  static values = { percentage: Number, victory: Boolean, completed: Boolean }

  connect() {
    // Victory audio only for level 10 win
    if (this.completedValue && this.victoryValue) {
      this.audio = new Audio("/audio/results-victory.mp3");
      this.audio.play();
    }
    // Death audio - every loss? or only level 10?
    else if (!this.victoryValue) {
      this.audio = new Audio("/audio/results-death.mp3");
      this.audio.play();
    }

    // Always animate (moved outside the if)
    setTimeout(() => this.animateCircle(), 300)
  }

  disconnect() {
    if (this.audio) {
      this.audio.pause();
      this.audio.currentTime = 0;
    }
  }

  getRankColor(percentage) {
    if (percentage === 100) return "#ffd700"  // S - gold
    if (percentage >= 80) return "#22c55e"    // A - green
    if (percentage >= 60) return "#3b82f6"    // B - blue
    if (percentage >= 40) return "#eab308"    // C - amber
    if (percentage >= 20) return "#f97316"    // D - orange
    return "#f87171"                          // F - red
  }

  animateCircle() {
    const circumference = 2 * Math.PI * 54
    const targetPercentage = this.percentageValue
    const duration = 1200
    const startTime = performance.now()

    this.circleTarget.style.strokeDasharray = circumference
    this.circleTarget.style.strokeDashoffset = circumference
    this.percentageTarget.textContent = "0%"

    // Start with F color
    this.circleTarget.style.stroke = this.getRankColor(0)

    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      const easeOut = 1 - Math.pow(1 - progress, 3)

      const currentPercentage = Math.round(easeOut * targetPercentage)
      const offset = circumference * (1 - (easeOut * targetPercentage / 100))

      // Update color based on current percentage
      this.circleTarget.style.stroke = this.getRankColor(currentPercentage)

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
    this.percentageTarget.style.transition = "opacity 0.2s"

    this.rankTarget.classList.add("rank-visible")

    if (this.victoryValue && this.hasPlayerSpriteTarget) {
      this.playerSpriteTarget.classList.add("celebrate")
    }

    setTimeout(() => {
      window.dispatchEvent(new CustomEvent("results:complete"))
    }, 500)
  }
}
