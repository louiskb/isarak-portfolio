// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

import "trix"
import "@rails/actiontext"

// Bootstrap + Turbo/stacking-context compatibility fixes.
//
// Problem 1 — persistent stacking context on <main>:
// The page-fade-in animation on <main> (transform + opacity) causes Chrome to
// promote <main> to a GPU compositing layer. Chrome keeps this layer even after
// the animation finishes — the persistent layer creates a stacking context that
// traps Bootstrap modals (inside <main>) below the backdrop (appended to <body>
// at z-index 1050, root context). Setting animation:none after animationend
// forces Chrome to demote the layer, collapsing the stacking context.
function watchMainAnimation() {
  const main = document.querySelector("main")
  if (!main) return
  main.addEventListener("animationend", () => {
    main.style.animation = "none"
  }, { once: true })
}
// Run on initial load and after every Turbo navigation (new <main> each time).
document.addEventListener("DOMContentLoaded", watchMainAnimation)
document.addEventListener("turbo:load", watchMainAnimation)

// Before Turbo snapshots the page for its cache, remove the inline override so
// the cached snapshot is clean — the CSS animation can re-run on restore.
document.addEventListener("turbo:before-cache", () => {
  const main = document.querySelector("main")
  if (main) main.style.removeProperty("animation")
})

// Problem 2 — Turbo body-swap leaves Bootstrap state behind:
// When a form inside a Bootstrap modal is submitted via Turbo, the server
// redirects and Turbo replaces body content. Bootstrap's .modal-backdrop and
// the modal-open class on <body> survive the swap, leaving the page frozen
// with a dark overlay and overflow:hidden. Clean up before Turbo renders.
document.addEventListener("turbo:before-render", () => {
  document.querySelectorAll(".modal-backdrop").forEach(el => el.remove())
  document.body.classList.remove("modal-open")
  document.body.style.removeProperty("padding-right")
  document.body.style.removeProperty("overflow")
})
