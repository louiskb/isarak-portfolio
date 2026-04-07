import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="teaching-spotlight"
// Pill buttons and arrow buttons switch the active teaching panel + image with a fade.
export default class extends Controller {
  static targets = ["card", "image", "pill"];

  connect() {
    this._current = 0;
  }

  select(event) {
    const index = parseInt(event.currentTarget.dataset.index);
    this._activate(index, "pill");
  }

  prev() {
    const next = (this._current - 1 + this.cardTargets.length) % this.cardTargets.length;
    this._activate(next, "prev");
  }

  next() {
    const next = (this._current + 1) % this.cardTargets.length;
    this._activate(next, "next");
  }

  _activate(index, method) {
    if (index === this._current) return;
    this._current = index;

    this.cardTargets.forEach((el, i) => el.classList.toggle("is-active", i === index));
    this.imageTargets.forEach((el, i) => el.classList.toggle("is-active", i === index));
    this.pillTargets.forEach((el, i) => el.classList.toggle("is-active", i === index));

    // PostHog: track carousel navigation
    if (typeof window.posthog !== "undefined" && window.posthog.capture) {
      const title = this.cardTargets[index]?.querySelector(".teaching-spotlight-title")?.textContent?.trim() || "";
      window.posthog.capture("teaching_spotlight_navigated", {
        direction: method,
        teaching_title: title
      });
    }
  }
}
