import { Controller } from "@hotwired/stimulus"

// Handles a resource index search bar + tag filter pills
// (blog posts, research items, teachings, grant awards).
// Auto-submits the GET form when a tag pill is clicked.
// Debounces the search input so it doesn't fire on every keypress.
// resourceValue prefixes the PostHog events (e.g. "blog" -> blog_searched);
// defaults to "blog" for backward compatibility.
export default class extends Controller {
  static values = { resource: { type: String, default: "blog" } }

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
        this._capture(`${this.resourceValue}_searched`, { query: query })
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
      this._capture(`${this.resourceValue}_tag_filtered`, { tag_name: tagName })
    }

    this.element.requestSubmit()
  }

  _capture(event, properties = {}) {
    if (typeof window.posthog !== "undefined" && window.posthog.capture) {
      window.posthog.capture(event, properties)
    }
  }
}
