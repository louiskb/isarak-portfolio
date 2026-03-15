import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="video-hero"
//
// Drives the hero background video by controlling playbackRate (not currentTime).
// Seeking via currentTime is inherently janky because video codecs must decode
// from the nearest keyframe — playbackRate lets the browser stream frames
// sequentially, which is buttery smooth.
//
// Scroll down → video plays forward at scroll-proportional speed.
// Scroll stops → video pauses (150 ms debounce).
// Scroll up → ignored (time-lapse only makes sense forward).
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

    this._lastScrollY = window.scrollY;
    this._lastScrollTime = performance.now();
    this._stopTimer = null;
    this._ticking = false;

    this.videoTarget.addEventListener("canplay", this._onLoaded.bind(this));
    this.videoTarget.addEventListener("error", this._hideVideo.bind(this));
  }

  disconnect() {
    window.removeEventListener("scroll", this._boundScroll);
    clearTimeout(this._stopTimer);
  }

  _onLoaded() {
    this.element.classList.add("hero-video-ready");
    this._boundScroll = this._onScroll.bind(this);
    window.addEventListener("scroll", this._boundScroll, { passive: true });
  }

  _onScroll() {
    if (this._ticking) return;
    this._ticking = true;

    requestAnimationFrame(() => {
      this._ticking = false;

      const now = performance.now();
      const currentY = window.scrollY;
      const deltaY = currentY - this._lastScrollY;
      const deltaT = Math.max(1, now - this._lastScrollTime);

      this._lastScrollY = currentY;
      this._lastScrollTime = now;

      if (deltaY > 0) {
        // Scrolling down — map velocity (px/ms) to a playback rate.
        // Tune the multiplier to taste: higher = video reacts more to fast scrolls.
        const velocity = deltaY / deltaT;
        const rate = Math.min(6, Math.max(0.5, velocity * 25));
        this.videoTarget.playbackRate = rate;
        this.videoTarget.play().catch(() => {});
      }

      // Pause the video shortly after scrolling stops
      clearTimeout(this._stopTimer);
      this._stopTimer = setTimeout(() => {
        this.videoTarget.pause();
      }, 150);
    });
  }

  _hideVideo() {
    this.videoTarget.remove();
  }
}
