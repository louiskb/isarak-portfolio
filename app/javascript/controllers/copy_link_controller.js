import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  copy() {
    navigator.clipboard.writeText(window.location.href).then(() => {
      this.iconTarget.className = "fa-solid fa-check"
      setTimeout(() => {
        this.iconTarget.className = "fa-solid fa-link"
      }, 2000)

      // PostHog: track link copy
      if (typeof window.posthog !== "undefined" && window.posthog.capture) {
        window.posthog.capture("blog_link_copied", {
          slug: window.location.pathname,
          title: document.querySelector(".blog-show-title")?.textContent?.trim() || ""
        })
      }
    })
  }
}
