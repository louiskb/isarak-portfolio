import { Controller } from "@hotwired/stimulus"

// Handles the blog index search bar + tag filter pills.
// Auto-submits the GET form when a tag pill is clicked.
// Debounces the search input so it doesn't fire on every keypress.
export default class extends Controller {
  connect() {
    this._searchTimer = null
  }

  disconnect() {
    clearTimeout(this._searchTimer)
  }

  // Called by data-action="input->blog-filter#search" on the search input.
  search(event) {
    clearTimeout(this._searchTimer)
    this._searchTimer = setTimeout(() => {
      const query = event.target.value.trim()
      if (query.length > 0) {
        this._capture("blog_searched", { query: query })
      }
      this.element.requestSubmit()
    }, 400)
  }

  // Called by data-action="change->blog-filter#submit" on tag checkboxes.
  submit(event) {
    const label = event.target.closest("label")
    const tagName = label?.textContent?.trim() || ""
    const checked = event.target.checked

    if (checked && tagName) {
      this._capture("blog_tag_filtered", { tag_name: tagName })
    }

    this.element.requestSubmit()
  }

  _capture(event, properties = {}) {
    if (typeof window.posthog !== "undefined" && window.posthog.capture) {
      window.posthog.capture(event, properties)
    }
  }
}
