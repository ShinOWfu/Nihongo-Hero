import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answer-feedback"
export default class extends Controller {
  // All targets needed for feedback
  static targets = ["answer", "player", "enemy", "enemyHealthbar", "enemyHealthText", "playerHealthbar", "playerHealthText", "scene"]
  // Creates getter for @question.correct_index, @damage_dealt & @damage_received
  static values = {
  correctIndex: Number,
  damageDealt: Number,
  damageReceived: Number,
  playerHp: Number,
  playerMaxHp: Number,
  enemyHp: Number,
  enemyMaxHp: Number
}

  feedback(event) {
    // Get the selected answer with index dataset on each button
    const selectedIndex = event.currentTarget.dataset.answerIndex

    // Compare the selected answer index with the getter of correct index
    const isCorrect = selectedIndex == this.correctIndexValue

    // Save a reference to the form to be able to submit after the timeout
    // Because if I do the timeout and then try to send the event closest form it can't find it anymore
    const form = event.currentTarget.closest('form');

    // Testing logs do not delete pls
    // console.log("Button clicked!")
    // console.log("Correct index is:", this.correctIndexValue)
    // console.log("Is the answer correct?:", isCorrect);
    // console.log("Damage dealt:", this.damageDealtValue);
    // console.log("Damage received:", this.damageReceivedValue);
    // console.log("Player target:", this.playerTarget)
    // console.log("Enemy target:", this.enemyTarget)
    // console.log("Player HP:", this.playerHpValue);
    // console.log("Enemy HP:", this.enemyHpValue);
    // console.log("Player Max HP:", this.playerMaxHpValue);
    // console.log("Enemy Max HP:", this.enemyMaxHpValue);

    event.preventDefault();

    // Disable all buttons so user can't click anymore
    this.answerTargets.forEach(button => {
      button.disabled = true;
    });

    if (isCorrect) {
      // If selected answer is correct -> highlight green
      event.currentTarget.classList.add("correct", "selected");

      // Create a div for dmg, add css, add dmg dealt text and append to enemy sprite
      const damageEl = document.createElement("div");
      damageEl.classList.add("damage-number");
      damageEl.textContent = `-${this.damageDealtValue}`;
      this.enemyTarget.appendChild(damageEl);

      // Calculate new HP
      const newEnemyHp = this.enemyHpValue - this.damageDealtValue
      // Calculate percentage, round to get exact number and max to make it not go below 0 for the bar
      const newPercent = Math.max(0, Math.round((newEnemyHp / this.enemyMaxHpValue) * 100))
      // Update the healthbar width
      this.enemyHealthbarTarget.style.width = `${newPercent}%`
      // Update the text
      this.enemyHealthTextTarget.textContent = `${newEnemyHp}HP`

      // Get the player/enemy sprites selected from within their targets
      const playerSprite = this.playerTarget.querySelector('.player-sprite');
      const enemySprite = this.enemyTarget.querySelector('.enemy-sprite');

      // 1- Player bumps forward
      playerSprite.classList.add("sword-strike");

      // 2- On impact flash enemy + shake screen
      setTimeout(() => {
        enemySprite.classList.add("hit-flash", "hit-recoil");
        this.sceneTarget.classList.add("screen-shake");
      }, 190); // screen shake halfway through the bump

      // 3- Clean up animation classes so they can replay next time
      setTimeout(() => {
        playerSprite.classList.remove("sword-strike");
        enemySprite.classList.remove("hit-flash", "hit-recoil");
        this.sceneTarget.classList.remove("screen-shake");
      }, 500);

    } else {
      // Find correct button if the answer was wrong
      const correctButton = this.answerTargets.find(button => button.dataset.answerIndex == this.correctIndexValue)

      const damageEl = document.createElement("div");
      damageEl.classList.add("damage-number");
      damageEl.textContent = `-${this.damageReceivedValue}`;
      this.playerTarget.appendChild(damageEl);

      // If selected answer is incorrect -> highlight red
      // Additionally correct answer -> highlight green
      event.currentTarget.classList.add("incorrect", "selected");
      correctButton.classList.add("correct");

      // Same blocks as up before
      const newPlayerHp = this.playerHpValue - this.damageReceivedValue
      const newPercent = Math.max(0, Math.round((newPlayerHp / this.playerMaxHpValue) * 100))
      this.playerHealthbarTarget.style.width = `${newPercent}%`
      this.playerHealthTextTarget.textContent = `${newPlayerHp}HP`

      this.enemyTarget.querySelector('.enemy-sprite').classList.add("lunge-left")
      setTimeout(() => {
        this.playerTarget.querySelector('.player-sprite').classList.add("shake")
      }, 300)
    }

    // Set delay to be longer if answer was incorrect
    const delay = isCorrect ? 1700 : 3200

    // Wait and then submit the form reference
    setTimeout(() => {
      form.submit();
    }, delay);
  }
}
