import { Controller } from "@hotwired/stimulus"

// Measures the actual rendered header height and writes it to the --navbar-height
// CSS custom property on <html>. This keeps the hero section's margin-top/padding-top
// perfectly in sync with the real navbar height regardless of browser, zoom level,
// or font size — no more guessing a fixed pixel value in SCSS.
//
// Also tracks scroll position and adds .header--scrolled to the header once the
// user passes 30% of the hero section height — CSS then switches the navbar
// background from transparent/glass to a solid dark base.
export default class extends Controller {
  connect() {
    this.update()
    this.resizeObserver = new ResizeObserver(() => this.update())
    this.resizeObserver.observe(this.element)

    this._boundScroll = this._onScroll.bind(this)
    window.addEventListener("scroll", this._boundScroll, { passive: true })
    this._onScroll()

    // Before Turbo snapshots the page for its cache, reset the scrolled class so
    // the cached snapshot is always in the clean unscrolled state.
    this._boundBeforeCache = () => this.element.classList.remove("header--scrolled")
    document.addEventListener("turbo:before-cache", this._boundBeforeCache)
  }

  disconnect() {
    this.resizeObserver?.disconnect()
    window.removeEventListener("scroll", this._boundScroll)
    document.removeEventListener("turbo:before-cache", this._boundBeforeCache)
  }

  update() {
    document.documentElement.style.setProperty(
      "--navbar-height",
      `${this.element.offsetHeight}px`
    )
  }

  _onScroll() {
    // Only toggle the scrolled state on the homepage — other pages keep their
    // navbar styling unchanged regardless of scroll position.
    const hero = document.querySelector(".home-hero")
    if (!hero) return
    this.element.classList.toggle("header--scrolled", window.scrollY > hero.offsetHeight * 0.3)
  }
}
