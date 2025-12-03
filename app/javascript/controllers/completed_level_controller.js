import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["storyBubble"]
  static values = { background: String, story: String }

  focus(event) {
    event.preventDefault()

    const isAlreadyFocused = this.element.classList.contains('node-completed--focused')

    // Remove focus and hide all other story bubbles
    document.querySelectorAll('.node-completed--focused').forEach(node => {
      node.classList.remove('node-completed--focused')
    })
    document.querySelectorAll('.completed-story-bubble--visible').forEach(bubble => {
      bubble.classList.remove('completed-story-bubble--visible')
    })

    // If it was already focused, just close (toggle off)
    if (isAlreadyFocused) {
      return
    }

    // Add focus to this node
    this.element.classList.add('node-completed--focused')

    // Show this story bubble
    if (this.hasStoryBubbleTarget) {
      this.storyBubbleTarget.classList.add('completed-story-bubble--visible')
    }

    // Center on screen
    this.element.scrollIntoView({
      behavior: 'smooth',
      block: 'center'
    })

    // Change background
    const mapContainer = document.getElementById('map-container')
    if (mapContainer && this.backgroundValue) {
      mapContainer.style.backgroundImage = `url('${this.backgroundValue}')`
    }
  }
}
