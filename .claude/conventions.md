# 程式碼慣例

## 多租戶隔離規則

**所有業務資料的 query 都必須從 `current_account` 出發**

```ruby
# ✅ 正確
current_account.shifts.find(params[:id])
current_account.employees.where(status: :active)

# ❌ 錯誤（跨租戶資料外洩風險）
Shift.find(params[:id])
Employee.all
```

---

## Controller 標準結構

```ruby
class FooController < ApplicationController
  layout "app"
  before_action :require_manager!   # 或 require_owner! / require_account!
  before_action :set_foo, only: [:show, :edit, :update, :destroy]

  def set_foo
    @foo = current_account.foos.find(params[:id])  # 必須從 current_account
  end
end
```

---

## Enum 對照表

### Membership.role
| value | 中文 | 權限 |
|---|---|---|
| `owner` | 擁有者 | 全部 |
| `manager` | 店長 | 員工管理、排班 |
| `staff` | 員工 | 查看 |

### Employee.status
| value | 中文 |
|---|---|
| `active` | 在職 |
| `inactive` | 離職 |
| `pending` | 待入職 |

### Shift.role_tag
| value | 中文 |
|---|---|
| `floor` | 外場 |
| `kitchen` | 內場 |
| `cashier` | 收銀 |

### Shift.source
| value | 中文 |
|---|---|
| `manual` | 手動 |
| `auto` | 自動 |
| `template` | 範本 |

### ShiftAssignment.status
| value | 中文 |
|---|---|
| `assigned` | 已指派 |
| `confirmed` | 已確認 |
| `declined` | 已拒絕 |
| `cancelled` | 已取消 |

---

## I18N Helper 位置

- `ApplicationHelper::ROLE_TAG_I18N` - role_tag 中文對照
- `ApplicationHelper::ASSIGNMENT_STATUS_I18N` - assignment status 中文對照
- `Membership::ROLE_I18N` - role 中文對照
- `Membership#role_i18n` - instance method

---

## View 規範

- layout：已登入業務頁 → `layouts/app.html.erb`
- `content_for :page_title` → 顯示在 top bar
- `content_for :header_actions` → 顯示在 top bar 右側（CTA 按鈕）
- flash 顯示：`shared/_flash`（已在 layout 中 render）
- 表單錯誤：`shared/_form_errors`（傳入 `object:`）

---

## 樂觀鎖（Shift）

`Shift` 有 `lock_version`，form 必須帶 `f.hidden_field :lock_version`

衝突時 controller rescue `ActiveRecord::StaleObjectError`，render edit with conflict status.
