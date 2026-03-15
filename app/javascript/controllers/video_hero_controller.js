import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="video-hero"
//
// Autoplays the hero video once it's ready — no scroll scrubbing, no playbackRate
// tricks. The outer .home-hero section is tall (150vh) so the sticky inner panel
// stays locked to the screen while the video runs; users must scroll past it
// naturally before the about section appears.
//
// Falls back gracefully to the static background-image if:
//   - The video fails to load / errors
//   - The user prefers reduced motion
export default class extends Controller {
  static targets = ["video"];

  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this._hideVideo();
      return;
    }

    this.videoTarget.addEventListener("canplay", this._onLoaded.bind(this));
    this.videoTarget.addEventListener("error", this._hideVideo.bind(this));
  }

  _onLoaded() {
    this.element.classList.add("hero-video-ready");
    this.videoTarget.play().catch(() => this._hideVideo());
  }

  _hideVideo() {
    this.videoTarget.remove();
  }
}
