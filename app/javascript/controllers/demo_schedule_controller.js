import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "content", "iconBg", "cost"]

  connect() {
    this.baseCost = 3200 // 初始薪資 (因為有兩個已填入的)
  }

  toggle(event) {
    // 找到被點擊的那個排班卡片 (event.currentTarget)
    const card = event.currentTarget
    
    // 讀取目前的狀態 (字串 "true" 或 "false")
    const isFilled = card.dataset.filled === "true"
    const staffName = card.dataset.staff
    
    // 切換狀態
    const newFilledState = !isFilled
    card.dataset.filled = newFilledState.toString()

    // 更新 UI 樣式與內容
    if (newFilledState) {
      this.fillSlot(card, staffName)
      this.updateCost(200) // 假設一個班加 200
    } else {
      this.emptySlot(card)
      this.updateCost(-200)
    }
  }

  fillSlot(card, name) {
    // 改變外框樣式
    card.classList.remove("border-slate-200", "border-dashed", "hover:border-orange-300", "hover:bg-slate-50")
    card.classList.add("border-orange-500", "bg-orange-50")

    // 改變標題顏色
    const title = card.querySelector('[data-demo-schedule-target="title"]')
    if (title) {
        title.classList.remove("text-slate-400")
        title.classList.add("text-slate-800")
    }

    // 改變 Icon 背景
    const iconBg = card.querySelector('[data-demo-schedule-target="iconBg"]')
    if (iconBg) {
        iconBg.classList.remove("bg-slate-100", "text-slate-400")
        iconBg.classList.add("bg-orange-100", "text-orange-600")
    }

    // 改變右側內容 (顯示名字 + 打勾)
    const content = card.querySelector('[data-demo-schedule-target="content"]')
    if (content) {
        content.innerHTML = `
          <span class="text-sm font-medium text-slate-700 bg-white px-3 py-1 rounded-full shadow-sm">${name}</span>
          <svg class="text-orange-500 w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
        `
    }
  }

  emptySlot(card) {
    // 恢復外框樣式
    card.classList.remove("border-orange-500", "bg-orange-50")
    card.classList.add("border-slate-200", "border-dashed", "hover:border-orange-300", "hover:bg-slate-50")

    // 恢復標題顏色
    const title = card.querySelector('[data-demo-schedule-target="title"]')
    if (title) {
        title.classList.remove("text-slate-800")
        title.classList.add("text-slate-400")
    }

    // 恢復 Icon 背景
    const iconBg = card.querySelector('[data-demo-schedule-target="iconBg"]')
    if (iconBg) {
        iconBg.classList.remove("bg-orange-100", "text-orange-600")
        iconBg.classList.add("bg-slate-100", "text-slate-400")
    }

    // 恢復右側內容 (顯示 "點擊安排")
    const content = card.querySelector('[data-demo-schedule-target="content"]')
    if (content) {
        content.innerHTML = `
          <span class="text-sm text-slate-400 group-hover:text-orange-500 font-medium">+ 點擊安排</span>
        `
    }
  }

  updateCost(amount) {
    this.baseCost += amount
    // 簡單的格式化金錢
    this.costTarget.innerText = `$${this.baseCost.toLocaleString()}`
  }
}
