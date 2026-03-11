import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="load-button"
export default class extends Controller {
  connect() {
    console.log("load_button connected!");
  }

  loader(event) {
    const form = this.element;
    form.insertAdjacentHTML(
      "beforeend",
      '<div class="btn btn-primary btn-lg rounded-5 mb-4 mt-4 disabled"><i class="fa-solid fa-spinner fa-spin"></i> Sending...</div>'
    );
    event.currentTarget.remove();
    form.requestSubmit();
  }
}
