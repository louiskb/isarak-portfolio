import { Controller } from "@hotwired/stimulus"

// Manages the split publish button on blog post forms.
// Controls hidden status + scheduled_at fields so the UI can drive
// the publishing workflow (draft / publish now / schedule) without
// exposing raw select inputs to Isara.
export default class extends Controller {
  static targets = ["statusInput", "scheduledAtInput", "scheduleInput"]
  static values = { currentStatus: String }

  // Default action — save the post as a draft.
  // Asks for confirmation if the post is currently published (would unpublish it).
  saveDraft(event) {
    event.preventDefault()
    if (this.currentStatusValue === "published") {
      if (!confirm("This will unpublish the post and move it back to draft. Continue?")) return
    }
    this.statusInputTarget.value = "draft"
    this.scheduledAtInputTarget.value = ""
    this.element.requestSubmit()
  }

  // Save without touching the status field (used on the edit form
  // when Isara just wants to update content without changing state).
  saveChanges(event) {
    event.preventDefault()
    this.element.requestSubmit()
  }

  // Publish immediately.
  publishNow(event) {
    event.preventDefault()
    this.statusInputTarget.value = "published"
    this.scheduledAtInputTarget.value = ""
    this.element.requestSubmit()
  }

  // Called by the "Schedule post" button inside the schedule modal.
  // Validates the datetime, sets the hidden fields, closes the modal,
  // then submits the form.
  confirmSchedule(event) {
    event.preventDefault()
    const val = this.scheduleInputTarget.value
    if (!val) return

    this.statusInputTarget.value = "scheduled"
    this.scheduledAtInputTarget.value = val

    const modalEl = this.element.querySelector("#schedulePostModal")
    if (modalEl) {
      const Modal = window.bootstrap?.Modal
      const bsModal = Modal.getInstance(modalEl) || new Modal(modalEl)
      modalEl.addEventListener("hidden.bs.modal", () => {
        this.element.requestSubmit()
      }, { once: true })
      bsModal.hide()
    } else {
      this.element.requestSubmit()
    }
  }
}
