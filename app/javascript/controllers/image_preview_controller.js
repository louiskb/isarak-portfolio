import { Controller } from "@hotwired/stimulus"

// Provides a live preview for image inputs (URL field or file upload).
// Usage:
//   data-controller="image-preview"
//   data-image-preview-target="urlInput"  → text field with URL
//   data-image-preview-target="fileInput" → file upload input
//   data-image-preview-target="preview"   → <img> tag (hidden until an image loads)
//
// Actions:
//   data-action="input->image-preview#updateUrl"  on the URL input
//   data-action="change->image-preview#updateFile" on the file input

export default class extends Controller {
  static targets = ["urlInput", "fileInput", "preview"]

  connect() {
    // If a URL is already pre-filled (e.g. on the revise page), show the preview.
    if (this.hasUrlInputTarget && this.urlInputTarget.value.trim()) {
      this.#showUrl(this.urlInputTarget.value.trim())
    }
  }

  updateUrl() {
    const url = this.urlInputTarget.value.trim()
    if (url) {
      this.#showUrl(url)
    } else {
      this.#hide()
    }
  }

  updateFile() {
    const file = this.fileInputTarget.files[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = (e) => this.#show(e.target.result)
    reader.readAsDataURL(file)
  }

  // ── private ──────────────────────────────────────────────────────────────

  #showUrl(url) {
    const img = this.previewTarget
    img.src = url
    img.onload = () => this.#show(url)
    img.onerror = () => this.#hide()
  }

  #show(src) {
    const img = this.previewTarget
    img.src = src
    img.classList.remove("d-none")
  }

  #hide() {
    this.previewTarget.classList.add("d-none")
    this.previewTarget.src = ""
  }
}
