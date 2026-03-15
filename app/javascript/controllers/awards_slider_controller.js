import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="awards-slider"
// Scrolls the track left/right by one card width on prev/next button clicks.
export default class extends Controller {
  static targets = ["track"];

  prev() {
    const card = this.trackTarget.querySelector(".awards-slider-card");
    if (!card) return;
    this.trackTarget.scrollBy({ left: -(card.offsetWidth + 24), behavior: "smooth" });
  }

  next() {
    const card = this.trackTarget.querySelector(".awards-slider-card");
    if (!card) return;
    this.trackTarget.scrollBy({ left: card.offsetWidth + 24, behavior: "smooth" });
  }
}
