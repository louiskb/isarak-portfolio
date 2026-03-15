import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="back-to-top"
//
// Shows a fixed chevron button in the bottom-right corner once the user has
// scrolled past 35% of the page height. Clicking it scrolls smoothly to the top.
export default class extends Controller {
  connect() {
    this._boundScroll = this._onScroll.bind(this)
    window.addEventListener("scroll", this._boundScroll, { passive: true })
    this._onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this._boundScroll)
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: "smooth" })
  }

  _onScroll() {
    const threshold = (document.documentElement.scrollHeight - window.innerHeight) * 0.25
    this.element.classList.toggle("back-to-top--visible", window.scrollY > threshold)
  }
}
