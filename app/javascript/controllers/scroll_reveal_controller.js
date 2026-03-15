import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="scroll-reveal"
// Watches the element with IntersectionObserver and adds .reveal-visible to
// [data-scroll-reveal-target="fromLeft"] and [data-scroll-reveal-target="fromRight"]
// when the section enters the viewport. CSS handles the actual animation.
export default class extends Controller {
  static targets = ["fromLeft", "fromRight"];

  connect() {
    this._observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          this.fromLeftTargets.forEach((el) => el.classList.add("reveal-visible"));
          this.fromRightTargets.forEach((el) => el.classList.add("reveal-visible"));
          this._observer.disconnect(); // animate once only
        });
      },
      { threshold: 0.15 }
    );
    this._observer.observe(this.element);
  }

  disconnect() {
    this._observer?.disconnect();
  }
}
