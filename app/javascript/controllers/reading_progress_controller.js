import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar"]

  connect() {
    this._update = this._update.bind(this)
    this._milestones = new Set()
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

    // Track reading milestones at 25%, 50%, 75%, 100%
    for (const milestone of [25, 50, 75, 100]) {
      if (progress >= milestone && !this._milestones.has(milestone)) {
        this._milestones.add(milestone)
        this._captureProgress(milestone)
      }
    }
  }

  _captureProgress(percent) {
    if (typeof window.posthog === "undefined" || !window.posthog.capture) return
    const title = document.querySelector(".blog-show-title")?.textContent?.trim() || ""
    window.posthog.capture("blog_read_progress", {
      percent: percent,
      title: title,
      slug: window.location.pathname
    })
  }
}
