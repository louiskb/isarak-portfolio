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

    const spinner = `<div class="mt-2"><span class="btn btn-primary btn-sm disabled"><i class="fa-solid fa-hourglass fa-spin me-1"></i> ${text}</span></div>`;

    if (this.hasButtonsTarget) {
      this.buttonsTarget.classList.add("d-none");
      this.buttonsTarget.insertAdjacentHTML("afterend", spinner);
    } else {
      this.element.insertAdjacentHTML("beforeend", spinner);
    }
  }
}
