import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="html-inject"
// Removes the `hidden` attribute once the controller connects, revealing sanitized HTML content.
// The content is sanitized server-side by Rails' sanitize() helper before this runs.
export default class extends Controller {
  connect() {
    this.element.removeAttribute("hidden");
  }
}
