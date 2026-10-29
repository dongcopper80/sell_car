# OtoChinhChu Mobile App (Flutter)

App mobile gọi trực tiếp **OtoChinhChu API** (NestJS, Postgres) — cùng backend với website và CMS.

## Cấu trúc
```
lib/
├── main.dart                     # entry + MaterialApp + SessionGate (đổi màn theo token)
├── core/
│   ├── api_client.dart           # Dio + Bearer token + envelope {code, data}
│   ├── session.dart              # SharedPreferences lưu phiên, StreamBloc-gate
│   └── models.dart               # Vehicle, CatalogItem, Deposit
└── features/
    ├── auth/login_screen.dart    # VNeID (placeholder) + email/pass (DN/CMS)
    ├── home/home_screen.dart     # BottomNav: Trang chủ | Tìm xe | Đăng tin / Đặt cọc | Tài khoản
    ├── search/search_screen.dart # Tìm theo từ khóa + nhiên liệu + hộp số
    ├── vehicle/vehicle_detail_screen.dart  # Gallery PageView + specs + đặt cọc
    ├── listing/new_listing_screen.dart     # Stepper 3 bước (chỉ role=business), ảnh ngoài
    ├── deposit/deposit_dialog.dart         # Dialog nhập số tiền + method
    ├── deposit/deposit_list_screen.dart    # Danh sách cọc của tôi
    └── profile/profile_screen.dart         # Thông tin + tin của tôi + thông báo
```

## Chạy

### 1. Chỉnh API endpoint
Mặc định app gọi `http://10.0.2.2:3000/api/v1` (10.0.2.2 = localhost trên Android emulator). Có thể override khi chạy:

```bash
flutter run --dart-define=API_BASE=http://10.0.2.2:3000/api/v1      # Android emulator
flutter run --dart-define=API_BASE=http://localhost:3000/api/v1     # iOS simulator / desktop
flutter run --dart-define=API_BASE=https://api.otochinhchu.vn/api/v1  # production
```

### 2. Cài dependencies & chạy
```bash
cd otochinhchu-app
flutter pub get
flutter run
```

### 3. Build release
```bash
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle (Play Store)
flutter build ipa          # iOS (cần macOS + Xcode)
```

## Quy tắc nghiệp vụ
- **Cá nhân**: bắt buộc đăng nhập qua VNeID (prototype hiển thị hướng dẫn; khi tích hợp thật sẽ mở OAuth deep link).
- **Doanh nghiệp**: đăng nhập email + mật khẩu (tài khoản được CMS cấp sau khi đối chiếu giấy tờ). Role `business` mới thấy tab **Đăng tin**.
- **Đặt cọc**: người mua tạo yêu cầu → chuyển khoản → admin CMS đối soát → trạng thái đổi thành `paid`; app tự nhận **Notification** in-app khi được cập nhật.
- **Đăng tin**: gửi đi ở trạng thái `draft` rồi `POST /vehicles/:id/submit` chuyển `pending_review` — chỉ hiển thị trên app khi admin duyệt (`published`).

## API endpoints được app dùng
| Endpoint | Mục đích |
|---|---|
| `POST /auth/login` | Đăng nhập DN/CMS |
| `GET /auth/me` | Lấy thông tin phiên |
| `GET /vehicles?keyword=&fuelType=&transmission=` | Tìm kiếm tin đăng |
| `GET /vehicles/:id` | Chi tiết xe |
| `POST /vehicles` + `POST /vehicles/:id/submit` | Đăng tin (business) |
| `GET /vehicles/mine/listings` | Tin của tôi |
| `POST /deposits` | Tạo đặt cọc |
| `GET /deposits/mine` | Danh sách cọc của tôi |
| `GET /catalog/makes|models|provinces` | Dropdown danh mục |
| `GET /notifications` | Hộp thông báo |
