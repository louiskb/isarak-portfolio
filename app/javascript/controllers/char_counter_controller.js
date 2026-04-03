import { Controller } from "@hotwired/stimulus"

// Displays a live character counter below an input/textarea.
// Usage:
//   <div data-controller="char-counter" data-char-counter-limit-value="250">
//     <input data-char-counter-target="input" … />
//     <span data-char-counter-target="display"></span>
//   </div>
//
// The counter text turns red when the count exceeds the soft limit.
export default class extends Controller {
  static targets = ["input", "display"]
  static values  = { limit: Number }

  connect() {
    this.update()
  }

  update() {
    const count = this.inputTarget.value.length
    const limit = this.limitValue
    this.displayTarget.textContent = `${count}/${limit} characters`

    if (count > limit) {
      this.displayTarget.classList.add("text-danger")
      this.displayTarget.classList.remove("text-success")
    } else {
      this.displayTarget.classList.add("text-success")
      this.displayTarget.classList.remove("text-danger")
    }
  }
}
