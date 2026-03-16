import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  copy() {
    navigator.clipboard.writeText(window.location.href).then(() => {
      this.iconTarget.className = "fa-solid fa-check"
      setTimeout(() => {
        this.iconTarget.className = "fa-solid fa-link"
      }, 2000)
    })
  }
}
