import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {newExp: Number, oldExp: Number, levelUp: Boolean}
  connect() {
  if (levelUp) {
    // --- First fill up to 100% to show level up ---
    this.element.style.width = '100%';
    // await new Promise(resolve => setTimeout(resolve, 300)); 

    // --- Then fill it to the new experience value percentage ---
    this.element.style.width = `${this.newExpValue}%`;

  } else {
    // --- Level Up is not true (Standard experience gain) ---
    this.element.style.width = `${this.newExpValue}%`;
  }
  }
}

