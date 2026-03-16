import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="link-spinner"
// Swaps a Font Awesome icon to a spinner when a Turbo link request fires.
// Only activates AFTER any turbo_confirm dialog is accepted — not on cancel.
//
// Usage:
//   data-controller="link-spinner"        ← on the <a> tag itself
//   data-link-spinner-target="icon"       ← on the <i> tag inside
//   data-link-spinner-spinner-value="fa-solid fa-hourglass fa-flip"  ← optional override
export default class extends Controller {
  static targets = ["icon"];
  static values = { spinner: { type: String, default: "fa-solid fa-hourglass fa-flip" } };

  connect() {
    this._onFetchRequest = this._onFetchRequest.bind(this);
    document.addEventListener("turbo:before-fetch-request", this._onFetchRequest);
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this._onFetchRequest);
  }

  _onFetchRequest(event) {
    if (event.detail.url.pathname === this.element.pathname) {
      this.iconTarget.className = this.spinnerValue;
    }
  }
}
