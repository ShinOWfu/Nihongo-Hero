import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["globalList", "friendsList", "toggleBtn", "soundIcon"]

  connect() {
    // Set initial state
    this.soundEnabled = true
  }

  switchTab(event) {
    const target = event.currentTarget.dataset.target

    // Update button states
    this.toggleBtnTargets.forEach(btn => {
      btn.classList.remove('active')
    })
    event.currentTarget.classList.add('active')

    // Show/hide lists
    this.globalListTarget.style.display = target === 'global' ? 'block' : 'none'
    this.friendsListTarget.style.display = target === 'friends' ? 'block' : 'none'
  }

  toggleSound() {
    this.soundEnabled = !this.soundEnabled

    if (this.soundEnabled) {
      this.soundIconTarget.classList.remove('fa-volume-xmark')
      this.soundIconTarget.classList.add('fa-volume-high')
      this.element.querySelector('.sound-toggle').classList.add('active')
    } else {
      this.soundIconTarget.classList.remove('fa-volume-high')
      this.soundIconTarget.classList.add('fa-volume-xmark')
      this.element.querySelector('.sound-toggle').classList.remove('active')
    }
  }
}
