import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar"]

  connect() {
    this._update = this._update.bind(this)
    window.addEventListener("scroll", this._update, { passive: true })
    this._update()
  }

  disconnect() {
    window.removeEventListener("scroll", this._update)
  }

  _update() {
    const scrollable = document.documentElement.scrollHeight - window.innerHeight
    const progress = scrollable > 0 ? Math.min((window.scrollY / scrollable) * 100, 100) : 0
    this.barTarget.style.width = `${progress}%`
  }
}
