import { Controller } from "@hotwired/stimulus"

// Measures the actual rendered header height and writes it to the --navbar-height
// CSS custom property on <html>. This keeps the hero section's margin-top/padding-top
// perfectly in sync with the real navbar height regardless of browser, zoom level,
// or font size — no more guessing a fixed pixel value in SCSS.
export default class extends Controller {
  connect() {
    this.update()
    this.resizeObserver = new ResizeObserver(() => this.update())
    this.resizeObserver.observe(this.element)
  }

  disconnect() {
    this.resizeObserver?.disconnect()
  }

  update() {
    document.documentElement.style.setProperty(
      "--navbar-height",
      `${this.element.offsetHeight}px`
    )
  }
}
