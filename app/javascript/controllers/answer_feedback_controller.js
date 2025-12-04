import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answer-feedback"
export default class extends Controller {
  static targets = ["answer", "player", "enemy", "enemyHealthbar", "enemyHealthText", "playerHealthbar", "playerHealthText", "scene"]
  static values = {
  correctIndex: Number,
  damageDealt: Number,
  damageReceived: Number,
  playerHp: Number,
  playerMaxHp: Number,
  enemyHp: Number,
  enemyMaxHp: Number,
  damageMultiplier: Number
}

  feedback(event) {
    // Get the selected answer with index dataset on each button
    const selectedIndex = event.currentTarget.dataset.answerIndex

    // Compare the selected answer index with the getter of correct index
    const isCorrect = selectedIndex == this.correctIndexValue

    // Save a reference to the form to be able to submit after the timeout
    const form = event.currentTarget.closest('form');

    event.preventDefault();

    // Disable all buttons so user can't click anymore
    this.answerTargets.forEach(button => {
      button.disabled = true;
    });

    if (isCorrect) {
      // If selected answer is correct -> highlight green
      event.currentTarget.classList.add("correct", "selected");

      const playerSprite = this.playerTarget.querySelector('.player-sprite');
      const enemySprite = this.enemyTarget.querySelector('.enemy-sprite');

      // 1- Player bumps forward
      playerSprite.classList.add("sword-strike");
      this.audio = new Audio("/audio/slash.mp3");
      this.audio.play();

      // On impact:
      setTimeout(() => {
        // Damage number with multiplier styling
        const damageEl = document.createElement("div");
        damageEl.classList.add("damage-number");
        if (this.damageMultiplierValue === 2) {
          damageEl.classList.add("critical");
        } else if (this.damageMultiplierValue === 0.5) {
          damageEl.classList.add("weak");
        }
        damageEl.textContent = `-${this.damageDealtValue}`;
        this.enemyTarget.appendChild(damageEl);

        // Effectiveness text
        if (this.damageMultiplierValue === 2) {
          const effectivenessEl = document.createElement("div");
          effectivenessEl.classList.add("effectiveness-text", "super-effective");
          effectivenessEl.textContent = "SUPER EFFECTIVE";
          this.sceneTarget.appendChild(effectivenessEl);
        } else if (this.damageMultiplierValue === 0.5) {
          const effectivenessEl = document.createElement("div");
          effectivenessEl.classList.add("effectiveness-text", "not-effective");
          effectivenessEl.textContent = "NOT EFFECTIVE...";
          this.sceneTarget.appendChild(effectivenessEl);
        }

        // HP update
        const newEnemyHp = this.enemyHpValue - this.damageDealtValue;
        const newPercent = Math.max(0, Math.round((newEnemyHp / this.enemyMaxHpValue) * 100));
        this.enemyHealthbarTarget.style.width = `${newPercent}%`;
        this.enemyHealthTextTarget.textContent = `${newEnemyHp}HP`;

        // Visual effects
        enemySprite.classList.add("hit-flash", "hit-recoil");
        this.sceneTarget.classList.add("screen-shake");

        // Death animation if HP <= 0
        if (newEnemyHp <= 0) {
          setTimeout(() => {
            // this.audio = new Audio("/audio/results-victory.mp3");
            // this.audio.play();
            enemySprite.classList.add("enemy-death");
          }, 300);
        }
      }, 270);

      // Cleanup
      setTimeout(() => {
        playerSprite.classList.remove("sword-strike");
        enemySprite.classList.remove("hit-flash", "hit-recoil");
        this.sceneTarget.classList.remove("screen-shake");
      }, 500);

    } else {
      // Find correct button if the answer was wrong
      const correctButton = this.answerTargets.find(button => button.dataset.answerIndex == this.correctIndexValue)

      event.currentTarget.classList.add("incorrect", "selected");
      correctButton.classList.add("correct");

      const playerSprite = this.playerTarget.querySelector('.player-sprite');
      const enemySprite = this.enemyTarget.querySelector('.enemy-sprite');

      // 1- Enemy lunges toward player
      enemySprite.classList.add("enemy-strike");
      this.audio = new Audio("/audio/damage.mp3");
      this.audio.play();

      setTimeout(() => {
        // Damage number
        const damageEl = document.createElement("div");
        damageEl.classList.add("damage-number");
        damageEl.textContent = `-${this.damageReceivedValue}`;
        this.playerTarget.appendChild(damageEl);

        // HP update
        const newPlayerHp = this.playerHpValue - this.damageReceivedValue;
        const newPercent = Math.max(0, Math.round((newPlayerHp / this.playerMaxHpValue) * 100));
        this.playerHealthbarTarget.style.width = `${newPercent}%`;
        this.playerHealthTextTarget.textContent = `${newPlayerHp}HP`;

        // Visual effects
        playerSprite.classList.add("hit-flash", "player-recoil");
        this.sceneTarget.classList.add("screen-shake");

        // Death animation if HP <= 0
        if (newPlayerHp <= 0) {
          setTimeout(() => {
            // this.audio = new Audio("/audio/results-death.mp3");
            // this.audio.play();
            playerSprite.classList.add("player-death");
          }, 300);
        }
      }, 270);

      // 3- Cleanup
      setTimeout(() => {
        enemySprite.classList.remove("enemy-strike");
        playerSprite.classList.remove("hit-flash", "player-recoil");
        this.sceneTarget.classList.remove("screen-shake");
      }, 500);
    }
    // Set delay to be longer if answer was incorrect
    const delay = isCorrect ? 1900 : 2100

    // // Wait and then submit the form reference
    setTimeout(() => {
      form.submit();
    }, delay);
    // Set delay to be longer if answer was incorrect OR if enemy was killed

    // In case you want the delays to be different if player or enemy dies
    // let delay = 2000; // default delay

    // if (isCorrect) {
    //   const newEnemyHp = this.enemyHpValue - this.damageDealtValue;
    //   if (newEnemyHp <= 0) {
    //     delay = 4000; // longer delay for victory
    //   }
    // } else {
    //   const newPlayerHp = this.playerHpValue - this.damageReceivedValue;
    //   if (newPlayerHp <= 0) {
    //     delay = 4000; // longer delay for defeat
    //   }
    // }

    // // Wait and then submit the form reference
    // setTimeout(() => {
    //   form.submit();
    // }, delay);
  }
}
