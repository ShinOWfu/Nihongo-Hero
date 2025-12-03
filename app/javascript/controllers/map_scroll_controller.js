// app/javascript/controllers/map_scroll_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["scrollContainer", "levelRow", "currentNode", "mysteryBubble"]
  static values = {
    currentLevel: Number,
    focusedLevel: Number
  }

  connect() {
    // Scroll to current level on page load
    this.scrollToCurrentLevel()

    // Set up scroll observer for background changes
    this.setupScrollObserver()

    // Close mystery bubble when clicking outside
    document.addEventListener("click", this.closeMysteryBubbles.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeMysteryBubbles.bind(this))
    if (this.scrollObserver) {
      this.scrollObserver.disconnect()
    }
  }

  // ===== SCROLL TO CURRENT LEVEL =====
  scrollToCurrentLevel() {
    setTimeout(() => {
      if (this.hasCurrentNodeTarget) {
        this.currentNodeTarget.scrollIntoView({
          behavior: "smooth",
          block: "center"
        })
      }
    }, 300)
  }

  // ===== FOCUS COMPLETED LEVEL =====
  focusLevel(event) {
    event.preventDefault()
    event.stopPropagation()

    const levelId = event.currentTarget.dataset.levelId
    const levelRow = this.levelRowTargets.find(
      row => row.dataset.levelId === levelId
    )

    if (!levelRow) return

    // Remove focus from all rows
    this.levelRowTargets.forEach(row => {
      row.classList.remove("level-row--focused")
    })

    // Add focus to clicked row
    levelRow.classList.add("level-row--focused")

    // Center the level on screen
    levelRow.scrollIntoView({
      behavior: "smooth",
      block: "center"
    })

    // Change background to this level's background
    const backgroundUrl = levelRow.dataset.levelBackground
    if (backgroundUrl) {
      this.changeBackground(backgroundUrl)
    }

    // Store focused level
    this.focusedLevelValue = parseInt(levelId)
  }

  // ===== SHOW MYSTERY BUBBLE FOR LOCKED LEVELS =====
  showMystery(event) {
    event.preventDefault()
    event.stopPropagation()

    const levelId = event.currentTarget.dataset.levelId

    // Close all other mystery bubbles first
    this.closeMysteryBubbles()

    // Find the mystery bubble for this level
    const bubble = this.mysteryBubbleTargets.find(
      b => b.dataset.forLevel === levelId
    )

    if (bubble) {
      bubble.classList.add("mystery-bubble--visible")

      // Auto-hide after 2 seconds
      setTimeout(() => {
        bubble.classList.remove("mystery-bubble--visible")
      }, 2000)
    }
  }

  closeMysteryBubbles(event) {
    // Don't close if clicking on a locked node
    if (event?.target?.closest(".node-locked")) return

    this.mysteryBubbleTargets.forEach(bubble => {
      bubble.classList.remove("mystery-bubble--visible")
    })
  }

  // ===== BACKGROUND CHANGES =====
  changeBackground(url) {
    const container = document.getElementById("map-container")
    if (container) {
      // Add fade transition
      container.style.transition = "background-image 0.5s ease-in-out"
      container.style.backgroundImage = `url('${url}')`
    }
  }

  // ===== SCROLL OBSERVER FOR BACKGROUND CHANGES =====
  setupScrollObserver() {
    const options = {
      root: this.scrollContainerTarget,
      rootMargin: "-40% 0px -40% 0px", // Trigger when level is in center-ish
      threshold: 0
    }

    this.scrollObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const levelRow = entry.target
          const isCompleted = levelRow.dataset.levelCompleted === "true"
          const levelId = parseInt(levelRow.dataset.levelId)

          // Only change background if level is completed or current
          if (isCompleted || levelId === this.currentLevelValue) {
            const backgroundUrl = levelRow.dataset.levelBackground
            if (backgroundUrl && !this.focusedLevelValue) {
              this.changeBackground(backgroundUrl)
            }
          }
        }
      })
    }, options)

    // Observe all level rows
    this.levelRowTargets.forEach(row => {
      this.scrollObserver.observe(row)
    })
  }

  // ===== RESET VIEW =====
  // Call this to go back to current level view
  resetToCurrentLevel() {
    // Remove all focused states
    this.levelRowTargets.forEach(row => {
      row.classList.remove("level-row--focused")
    })

    // Clear focused level
    this.focusedLevelValue = null

    // Scroll to current
    this.scrollToCurrentLevel()
  }
}
