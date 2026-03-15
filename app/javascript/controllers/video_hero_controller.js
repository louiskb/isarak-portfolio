import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="video-hero"
//
// Scroll-scrubs the hero background video so scrolling through the hero
// drives video.currentTime — creating a scroll-triggered time lapse effect.
//
// The full video completes over 70% of the hero height so the transition
// feels fast and dramatic rather than stretched across the full scroll.
//
// Falls back gracefully to the static background-image if:
//   - The video fails to load / errors
//   - The user prefers reduced motion
//
// Production note: for best performance host the video on Cloudinary
// (CDN delivery, adaptive streaming) and update the <source src>.
export default class extends Controller {
  static targets = ["video"];

  connect() {
    // Respect reduced-motion preference — static image only
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this._hideVideo();
      return;
    }

    this._ticking = false;
    this._boundScrollHandler = this._onScroll.bind(this);

    this.videoTarget.addEventListener(
      "loadedmetadata",
      this._onLoaded.bind(this)
    );
    this.videoTarget.addEventListener("error", this._hideVideo.bind(this));
  }

  disconnect() {
    window.removeEventListener("scroll", this._boundScrollHandler);
  }

  _onLoaded() {
    // Fade in the video over the fallback image
    this.element.classList.add("hero-video-ready");
    // Set correct time immediately in case the page loaded mid-scroll
    this._updateTime();
    window.addEventListener("scroll", this._boundScrollHandler, {
      passive: true,
    });
  }

  _onScroll() {
    if (!this._ticking) {
      requestAnimationFrame(() => {
        this._updateTime();
        this._ticking = false;
      });
      this._ticking = true;
    }
  }

  _updateTime() {
    // Scrollable range = outer section height minus one viewport height.
    // At scroll = 0 the sticky panel just entered view; at scroll = scrollRange
    // the sticky panel is about to leave and the about section appears.
    const scrollRange = this.element.offsetHeight - window.innerHeight;
    const scrolled = Math.max(
      0,
      -this.element.getBoundingClientRect().top
    );
    const progress = Math.min(1, scrolled / scrollRange);
    this.videoTarget.currentTime = progress * this.videoTarget.duration;
  }

  _hideVideo() {
    this.videoTarget.remove();
  }
}
