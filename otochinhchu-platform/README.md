# OtoChinhChu Platform

Web + CMS + API (dành cho app mobile) — NestJS 10 + TypeORM + PostgreSQL, kế thừa kiến trúc từ `api.otochinhchu.vn` (module theo domain, JWT/roles guards, Swagger) và giao diện theo prototype `c:\Projects\oto`.

## Cấu trúc
```
otochinhchu-platform/
├── src/                 # NestJS API (port 3000, prefix /api/v1)
│   ├── auth/            # JWT + VNeID callback
│   ├── common/          # guards (JWT, RBAC), interceptor, exception chuẩn
│   ├── config/          # TypeORM Postgres config
│   ├── database/
│   │   ├── entities/    # User, BusinessAccount, BusinessDocument, Vehicle, Deposit, CatalogItem, AuditLog, Notification
│   │   └── seeds/       # npm run seed
│   └── modules/
│       ├── users/               # CRUD user (admin)
│       ├── vehicles/            # đăng tin, tìm kiếm, duyệt tin (state machine)
│       ├── business-accounts/   # CMS tạo tài khoản DN thủ công sau xác minh
│       ├── deposits/            # đặt cọc: Pending → Verifying → Paid
│       ├── catalog/             # danh mục động (hãng/dòng/tỉnh...)
│       ├── notifications/, files/, audit/
├── web/   (port 3001)   # SPA website công khai
├── cms/   (port 3002)   # SPA quản trị
└── public/uploads       # ảnh tải lên
```

## Chạy
### Cách 1 — Docker (khuyên dùng, chạy toàn bộ stack)
```bash
docker compose up -d --build     # db + api + seed + web + cms
# seed chạy 1 lần tự động; xem log:
docker compose logs -f seed api
# dừng: docker compose down  (giữ dữ liệu)  |  xóa dữ liệu: docker compose down -v
```

### Cách 2 — Chạy local không Docker
```bash
cp .env.example .env      # chỉnh DB_* và JWT_SECRET
npm install
npm run build && npm run seed
npm run start:prod        # API  http://localhost:3000/api/docs
cd web  && PORT=3001 node server.js   # web
cd cms  && PORT=3002 node server.js   # cms
```

Tài khoản seed: `admin@otochinhchu.vn / admin123` · `salon@otochinhchu.vn / salon123` · `buyer@otochinhchu.vn / buyer123`

## Nguyên tắc đã hiện thực (theo prototype)
- Cá nhân **bắt buộc** đăng nhập VNeID — không có form email/mật khẩu public.
- Tài khoản doanh nghiệp **chỉ admin tạo** trong CMS (`POST /cms/business-accounts`) sau khi checklist đủ 4 loại giấy tờ (GCN ĐKKD, MST, TK ngân hàng, người đại diện); có `documentsVerified`, `verifiedAt`, audit log, state machine `pending → active ⇄ suspended`.
- Đặt cọc: user không thể tự xác nhận `Paid`; chỉ admin CMS xác nhận sau đối soát, kèm thông báo cho người mua.
- Duyệt tin: state machine `draft → pending_review → published/rejected`, chặn nhảy cóc.

## Tính kế thừa & mở rộng
- Thêm module mới: tạo `src/modules/<name>` với service/controller/module, đăng ký vào `AppModule` — không cần sửa gì khác.
- Thêm trạng thái: sửa enum + map flow (`VEHICLE_STATUS_FLOW`, `DEPOSIT_STATUS_FLOW`, `ACCOUNT_STATUS_FLOW`).
- Thêm danh mục: `catalog_items` theo `groupCode` (makes, models, provinces...) — không cần ALTER bảng.
- Swagger tự sinh tại `/api/docs` cho app mobile consume.
