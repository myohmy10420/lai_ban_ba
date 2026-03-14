import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["location", "date", "startsAt", "endsAt", "hint"]

  // 門市或日期任一改變時觸發
  autofill() {
    const locationId = this.locationTarget.value
    const dateVal = this.dateTarget.value  // "2026-03-14"
    if (!locationId || !dateVal) return

    const date = new Date(dateVal)
    const dayOfWeek = date.getDay()  // 0=週日 … 6=週六

    fetch(`/locations/${locationId}/business_hours?day_of_week=${dayOfWeek}`, {
      headers: { "Accept": "application/json" }
    })
      .then(r => r.json())
      .then(data => {
        if (data.closed) {
          this.hintTarget.textContent = "該門市當天公休"
          this.hintTarget.className = "text-xs text-red-500 mt-1"
          return
        }
        // 把日期 + 營業時間組合成 datetime-local 格式
        this.startsAtTarget.value = `${dateVal}T${data.opens_at}`
        this.endsAtTarget.value   = `${dateVal}T${data.closes_at}`
        this.hintTarget.textContent = `已帶入營業時間 ${data.opens_at} – ${data.closes_at}`
        this.hintTarget.className = "text-xs text-slate-400 mt-1"
      })
  }
}
