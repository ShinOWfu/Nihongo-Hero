import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answer-highlight"
export default class extends Controller {
  // Create a target on the button that the user selects
  static targets = ["answer"]
  // Creates getter for data-answer-highlight-correct-index-value which is @question.correct_index
  static values = {
    correctIndex: Number
  }

  // Highlight correct answer with green, and wrong answer with red
  highlight(event) {
    // Get the selected answer with index dataset on each button
    const selectedIndex = event.currentTarget.dataset.answerIndex
    // Compare the selected answer index with the getter of correct index
    const isCorrect = selectedIndex == this.correctIndexValue
    // Save a reference to the form to find it after the timeout
    const form = event.currentTarget.closest('form');

    // console.log("Button clicked!")
    // console.log("Correct index is:", this.correctIndexValue)
    // console.log("Is the answer correct?:", isCorrect);

    event.preventDefault();

    // If selected answer is correct -> highlight green
    if (isCorrect) {
      event.currentTarget.classList.add("correct");

    // If selected answer is incorrect -> highlight red
    // Additionally correct answer -> highlight green
    } else {
      // Find correct button if the answer was wrong
      const correctButton = this.answerTargets.find(button => button.dataset.answerIndex == this.correctIndexValue)
      event.currentTarget.classList.add("incorrect");
      correctButton.classList.add("correct");
    }

    setTimeout(() => {
      form.submit();
    }, 3000);
  }
}
