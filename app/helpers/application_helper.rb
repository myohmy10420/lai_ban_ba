module ApplicationHelper
  ROLE_TAG_I18N = { "floor" => "外場", "kitchen" => "內場", "cashier" => "收銀" }.freeze
  ASSIGNMENT_STATUS_I18N = { "assigned" => "已指派", "confirmed" => "已確認", "declined" => "已拒絕", "cancelled" => "已取消" }.freeze

  def month_calendar_days(month_start)
    pad_before = month_start.wday
    month_end   = month_start.end_of_month
    total       = pad_before + month_end.day
    pad_after   = (7 - total % 7) % 7
    Array.new(pad_before) + (month_start..month_end).to_a + Array.new(pad_after)
  end

  def nav_link_to(label, path, icon: nil)
    active = current_page?(path)
    link_class = [
      "flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition",
      active ? "bg-orange-500 text-white" : "text-slate-400 hover:text-white hover:bg-slate-700"
    ].join(" ")

    link_to path, class: link_class do
      content = "".dup
      if icon
        content << content_tag(:svg, icon.html_safe,
          class: "w-5 h-5 flex-shrink-0",
          fill: "none", stroke: "currentColor", viewBox: "0 0 24 24",
          xmlns: "http://www.w3.org/2000/svg")
      end
      content << content_tag(:span, label)
      content.html_safe
    end
  end
end
