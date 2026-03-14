import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["location", "roleTag", "startsAt", "endsAt", "headcount",
                    "cell", "toggleBtn", "toggleLabel", "hint"]
  static values  = { active: Boolean }

  connect() {
    this.painting   = false
    this.pendingDates = new Set()
    this._mouseupHandler = this.globalMouseup.bind(this)
    window.addEventListener("mouseup", this._mouseupHandler)
  }

  disconnect() {
    window.removeEventListener("mouseup", this._mouseupHandler)
  }

  toggle() {
    this.activeValue = !this.activeValue
  }

  activeValueChanged() {
    const on = this.activeValue
    if (this.hasToggleLabelTarget) {
      this.toggleLabelTarget.textContent = on ? "關閉油漆刷" : "開啟油漆刷"
    }
    if (this.hasToggleBtnTarget) {
      this.toggleBtnTarget.className = this.toggleBtnTarget.className
        .replace(/border-\S+ bg-\S+ text-\S+/, "")
      if (on) {
        this.toggleBtnTarget.classList.add("border-orange-400", "bg-orange-500", "text-white")
        this.toggleBtnTarget.classList.remove("border-slate-300", "bg-white", "text-slate-600")
      } else {
        this.toggleBtnTarget.classList.add("border-slate-300", "bg-white", "text-slate-600")
        this.toggleBtnTarget.classList.remove("border-orange-400", "bg-orange-500", "text-white")
      }
    }
    // 格子 cursor
    this.cellTargets.forEach(cell => {
      cell.style.cursor = on ? "crosshair" : "default"
    })
    if (this.hasHintTarget) {
      this.hintTarget.textContent = on ? "點選或拖曳格子來批次建立班次" : ""
    }
  }

  cellMousedown(event) {
    if (!this.activeValue) return
    event.preventDefault()
    this.painting = true
    this.pendingDates.clear()
    this.markCell(event.currentTarget)
  }

  cellMouseenter(event) {
    if (!this.painting) return
    this.markCell(event.currentTarget)
  }

  globalMouseup() {
    if (!this.painting) return
    this.painting = false
    if (this.pendingDates.size > 0) this.submitBatch()
  }

  markCell(cell) {
    cell.classList.add("bg-orange-100", "ring-2", "ring-inset", "ring-orange-400")
    this.pendingDates.add(cell.dataset.date)
  }

  clearMarks() {
    this.cellTargets.forEach(cell => {
      cell.classList.remove("bg-orange-100", "ring-2", "ring-inset", "ring-orange-400")
    })
    this.pendingDates.clear()
  }

  submitBatch() {
    if (!this.hasLocationTarget || !this.locationTarget.value) {
      alert("請先選擇門市")
      this.clearMarks()
      return
    }

    const payload = {
      shifts: Array.from(this.pendingDates).map(date => ({
        date,
        location_id:        this.locationTarget.value,
        role_tag:           this.roleTagTarget.value,
        starts_at_time:     this.startsAtTarget.value,
        ends_at_time:       this.endsAtTarget.value,
        required_headcount: this.headcountTarget.value
      }))
    }

    const csrf = document.querySelector("meta[name=csrf-token]")?.content

    fetch("/shifts/batch_create", {
      method:  "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": csrf },
      body:    JSON.stringify(payload)
    })
      .then(r => r.json())
      .then(data => {
        if (data.ok) {
          window.Turbo?.visit(window.location.href) || window.location.reload()
        } else {
          alert("建立失敗：\n" + (data.errors || []).join("\n"))
          this.clearMarks()
        }
      })
      .catch(() => {
        alert("網路錯誤，請重試")
        this.clearMarks()
      })
  }
}
