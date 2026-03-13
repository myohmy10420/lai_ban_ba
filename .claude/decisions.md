# 架構決策記錄（ADR）

## D001 - employees.location_id vs employee_location_memberships

**決策**：MVP 保留 `employees.location_id`（主門市），不建 `employee_location_memberships`

**原因**：
- CLAUDE.md 原設計有獨立 join table 支援跨店
- 但 migration 已建成 `employees.location_id NOT NULL`，短期改動成本高
- MVP 只需一主門市即可排班，跨店是下一 milestone

**影響**：
- `Employee` 目前只屬於一間門市
- 未來要加跨店時，需要新 migration + model + UI

---

## D002 - 多租戶採 session-based current_account

**決策**：`session[:current_account_id]` 存目前帳號，不用 subdomain

**原因**：MVP 速度優先，subdomain 需要 DNS/nginx 設定

**影響**：
- `current_account` 在 `ApplicationController` 中 fallback 為 `user.accounts.first`
- 多帳號切換用 `POST /accounts/:id/switch`

---

## D003 - enum 用 string 值而非 integer

**決策**：所有 enum（role、status、role_tag 等）用 string 值（`{ owner: "owner" }`）

**原因**：字串更易讀，DB 直接看值不需要對照表，migration 重排不影響資料

---

## D004 - 授權階層

```
owner > manager > staff
```

| 功能 | owner | manager | staff |
|---|---|---|---|
| 門市 CRUD | ✅ | ❌ | ❌ |
| 員工 CRUD | ✅ | ✅ | ❌ |
| 班次 CRUD | ✅ | ✅ | ❌（只能查看） |
| 指派員工 | ✅ | ✅ | ❌ |

---

## D005 - layout 分離策略

- `layouts/application.html.erb`：Landing page、Devise、Onboarding
- `layouts/app.html.erb`：所有需要登入的業務頁面（sidebar）

各 controller 明確宣告 `layout "app"`，不用 conditional。

---

## D006 - ShiftAssignment.assigned_by_user_id

**欄位**：nullable FK → users.id

**原因**：自動派班（`source: auto`）時沒有人工操作者，故 optional
