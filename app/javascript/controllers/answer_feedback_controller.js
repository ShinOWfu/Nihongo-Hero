import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answer-feedback"
export default class extends Controller {
  // Create a target on the button that the user selects
  static targets = ["answer", "player", "enemy"]
  // Creates getter for @question.correct_index, @damage_dealt & @damage_received
  static values = {
    correctIndex: Number,
    damageDealt: Number,
    damageReceived: Number
  }

  feedback(event) {
    // Get the selected answer with index dataset on each button
    const selectedIndex = event.currentTarget.dataset.answerIndex

    // Compare the selected answer index with the getter of correct index
    const isCorrect = selectedIndex == this.correctIndexValue

    // Save a reference to the form to be able to submit after the timeout
    // Because if I do the timeout and then try to send the event closest form it can't find it anymore
    const form = event.currentTarget.closest('form');

    // console.log("Button clicked!")
    // console.log("Correct index is:", this.correctIndexValue)
    // console.log("Is the answer correct?:", isCorrect);
    // console.log("Damage dealt:", this.damageDealtValue);
    // console.log("Damage received:", this.damageReceivedValue);
    // console.log("Player target:", this.playerTarget)
    // console.log("Enemy target:", this.enemyTarget)

    event.preventDefault();

    // Disable all buttons so user can't click anymore
    this.answerTargets.forEach(button => {
      button.disabled = true;
    });

    if (isCorrect) {
      // If selected answer is correct -> highlight green
      event.currentTarget.classList.add("correct", "selected");
      const damageEl = document.createElement("div");
      damageEl.textContent = `-${this.damageDealtValue}`;
      this.enemyTarget.appendChild(damageEl);

    } else {
      // Find correct button if the answer was wrong
      const correctButton = this.answerTargets.find(button => button.dataset.answerIndex == this.correctIndexValue)

      const damageEl = document.createElement("div");
      damageEl.textContent = `-${this.damageReceivedValue}`;
      this.playerTarget.appendChild(damageEl);

      // If selected answer is incorrect -> highlight red
      // Additionally correct answer -> highlight green
      event.currentTarget.classList.add("incorrect", "selected");
      correctButton.classList.add("correct");
    }

    // Set delay to be longer if answer was incorrect
    const delay = isCorrect ? 1700 : 3300

    // Wait and then submit the form reference
    setTimeout(() => {
      form.submit();
    }, delay);
  }
}
