import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="load-button"
// Shows a spinner and hides the button group when a form is submitted.
//
// Mark the button group wrapper: data-load-button-target="buttons"
// On buttons that also submit the form: data-action="click->load-button#loader ..."
// On buttons where another controller handles submission: data-action="click->load-button#showSpinner ..."
// Optional per-button loading text: data-load-button-loading-text-value="Generating..."
export default class extends Controller {
  static targets = ["buttons"];
  static values = { loadingText: { type: String, default: "Sending..." } };

  connect() {
    console.log("load_button connected!");
  }

  // Hide buttons, show spinner, and submit the form.
  // Use this when load-button is responsible for form submission.
  loader(event) {
    this._showSpinner(event);
    this.element.requestSubmit();
  }

  // Hide buttons and show spinner WITHOUT submitting.
  // Use this when another controller (e.g. publish-form) handles submission.
  showSpinner(event) {
    this._showSpinner(event);
  }

  _showSpinner(event) {
    const text =
      event?.currentTarget?.dataset?.loadButtonLoadingTextValue ||
      this.loadingTextValue;

    // Inherit the triggering button's visual classes so the spinner matches.
    // Strip structural/split-button classes, dropdown-item, and spacing utilities that don't belong on a static span.
    // If stripping leaves nothing (e.g. a bare dropdown-item click), fall back to the primary publish button style.
    const STRIP = /\b(btn-publish-main|btn-publish-chevron|dropdown-toggle-split|dropdown-toggle|dropdown-item|[mp][trblxy]?-\d+)\b/g;
    const stripped = event?.currentTarget
      ? event.currentTarget.className.replace(STRIP, "").replace(/\s+/g, " ").trim()
      : "";
    const btnClasses = stripped || "btn btn-blog-publish";

    const spinner = `<div class="mt-4 mb-4"><span class="${btnClasses}" style="pointer-events:none;cursor:default"><i class="fa-solid fa-hourglass fa-spin me-1"></i> ${text}</span></div>`;

    if (this.hasButtonsTarget) {
      this.buttonsTarget.classList.add("d-none");
      this.buttonsTarget.insertAdjacentHTML("afterend", spinner);
    } else {
      this.element.insertAdjacentHTML("beforeend", spinner);
    }
  }
}
