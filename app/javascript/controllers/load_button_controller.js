import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="load-button"
// Supports a custom loading message via a Stimulus value:
//   data-load-button-loading-text-value="Generating your post..."
// Falls back to "Sending..." if no value is provided.
export default class extends Controller {
  static values = { loadingText: { type: String, default: "Sending..." } };

  connect() {
    console.log("load_button connected!");
  }

  loader(event) {
    const form = this.element;
    const text = this.loadingTextValue;

    form.insertAdjacentHTML(
      "beforeend",
      `<div class="btn btn-primary btn-lg rounded-5 mb-4 mt-4 disabled"><i class="fa-solid fa-spinner fa-spin"></i> ${text}</div>`
    );
    event.currentTarget.remove();
    form.requestSubmit();
  }
}
