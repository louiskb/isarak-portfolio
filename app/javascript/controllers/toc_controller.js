import { Controller } from "@hotwired/stimulus"

// Builds a table of contents from h2/h3 headings in the content target.
// Desktop (lg+): reveals a sticky sidebar column.
// Mobile (<lg):  reveals an inline nav block above the content.
// Both lists share active-section highlighting as the user scrolls.
export default class extends Controller {
  static targets = ["content", "sidebar", "mobileNav", "list"]

  connect() {
    this._build()
  }

  disconnect() {
    if (this._cleanup) this._cleanup()
  }

  _build() {
    const headings = this.contentTarget.querySelectorAll("h1, h2, h3")
    if (headings.length < 2) return

    // Assign stable IDs to any headings that don't already have one
    headings.forEach((heading, i) => {
      if (!heading.id) heading.id = `section-${i}`
    })

    // Populate every list target (sidebar ul + mobile ul)
    this.listTargets.forEach(listEl => {
      headings.forEach(heading => {
        const li = document.createElement("li")
        const a = document.createElement("a")
        a.href = `#${heading.id}`
        a.textContent = heading.textContent
        a.className = heading.tagName === "H3" ? "toc-link toc-link-sub" : "toc-link toc-link-top"
        li.appendChild(a)
        listEl.appendChild(li)
      })
    })

    // Desktop: reveal sidebar column at lg+
    this.sidebarTarget.classList.add("d-lg-block")

    // Mobile: reveal inline nav (hidden attr removed; d-lg-none keeps it desktop-hidden)
    this.mobileNavTarget.hidden = false

    this._setupActiveTracking()
  }

  _setupActiveTracking() {
    const navbarOffset = parseInt(
      getComputedStyle(document.documentElement).getPropertyValue("--navbar-height") || "74",
      10
    )

    const track = () => {
      const headings = Array.from(this.contentTarget.querySelectorAll("h1, h2, h3"))
      const scrollY = window.scrollY + navbarOffset + 60

      let active = null
      for (const heading of headings) {
        if (heading.offsetTop <= scrollY) active = heading
      }

      const allLinks = this.listTargets.flatMap(list =>
        Array.from(list.querySelectorAll(".toc-link"))
      )
      allLinks.forEach(l => l.classList.remove("toc-active"))

      if (active) {
        allLinks
          .filter(l => l.getAttribute("href") === `#${active.id}`)
          .forEach(l => l.classList.add("toc-active"))
      }
    }

    window.addEventListener("scroll", track, { passive: true })
    track()
    this._cleanup = () => window.removeEventListener("scroll", track)
  }
}
