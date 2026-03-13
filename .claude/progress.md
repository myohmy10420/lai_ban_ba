# 實作進度追蹤

## 已完成 ✅

### 資料庫 & Models
- [x] 7 張核心 migration（users/accounts/locations/employees/memberships/shifts/shift_assignments）
- [x] Migration fix：`employees.user_id` 改為 nullable、補 indexes
- [x] 全部 models 補強（validations、enums、associations、scopes）
- [x] `Membership` enum role：owner / manager / staff
- [x] `Employee` enum status：active / inactive / pending
- [x] `Shift` enum role_tag（floor/kitchen/cashier）、source（manual/auto/template）
- [x] `ShiftAssignment` enum status：assigned / confirmed / declined / cancelled
- [x] `Shift#fully_staffed?`、`duration_hours` 方法
- [x] 樂觀鎖（`lock_version`）保護 Shift

### 授權 & 多租戶
- [x] `current_account`：session-based，fallback 第一個 account
- [x] `current_membership`：目前 account 的角色
- [x] `require_account!` / `require_manager!` / `require_owner!`
- [x] `after_sign_in_path_for`：有帳號 → dashboard，沒有 → onboarding

### Controllers（6 個）
- [x] `DashboardController`
- [x] `AccountsController`（new/create/switch）
- [x] `LocationsController`（完整 CRUD）
- [x] `EmployeesController`（完整 CRUD）
- [x] `ShiftsController`（完整 CRUD + 樂觀鎖衝突處理）
- [x] `ShiftAssignmentsController`（create/destroy/confirm/decline/cancel）

### Views（老闆 MVP）
- [x] `layouts/app.html.erb`（sidebar layout）
- [x] `accounts/new`（onboarding）
- [x] `dashboard/index`（概覽 + 統計 + 快速引導）
- [x] `locations/` index/new/edit + form partial
- [x] `employees/` index/new/edit + form partial
- [x] `shifts/` index（日期導航）/ show（指派面板）/ new/edit + form partial
- [x] `shared/_flash` / `shared/_form_errors`

---

## 待辦 ❌

### 高優先
- [ ] Devise views 樣式統一（登入/註冊頁目前預設樣式）
- [ ] Turbo Stream：指派員工 `shifts/show` 頁面 partial 更新（不需要 full page reload）
- [ ] `shift_assignments/` turbo_stream templates（create.turbo_stream.erb / destroy.turbo_stream.erb）

### 中優先
- [ ] 勞基法 rule engine（連上超過 X 小時、每週工時上限等）
- [ ] 班次衝突偵測（同一員工同時間被指派兩個班次）
- [ ] 員工 `show` 頁面（班次歷史、工時統計）

### 未來 milestone
- [ ] `employee_location_memberships` 表（跨店支援）
  - 目前 MVP 用 `employees.location_id` 作為主門市，跨店留到之後
- [ ] 替班流程自動化（push 通知、一鍵回覆）
- [ ] PWA / Turbo Native 導入
- [ ] 班表拖拉 Hotwire UI
- [ ] 成員邀請機制（manager/staff 加入 account）
- [ ] Memberships 管理 UI
