# Aoto Marketplace & CMS

Prototype giao diện cho Aoto.com.vn, gồm Public Website và Admin CMS. Dữ liệu đều là dữ liệu minh họa; ứng dụng chạy trực tiếp trên trình duyệt, không cần cài dependency hoặc khởi động server.

## Mở ứng dụng

Mở `index.html` bằng trình duyệt. Từ trang chủ, dùng menu chính để chuyển giữa Website và CMS. Trên điện thoại, menu thu gọn thành nút điều hướng.

## Khu vực Website

- Trang chủ, tìm kiếm xe, bộ lọc theo hãng/giá/nhiên liệu/địa điểm, sắp xếp và trang chi tiết xe.
- Hồ sơ người bán/showroom, xe đã lưu, hồ sơ cá nhân, thông báo và tìm kiếm đã lưu.
- Trang Hướng dẫn sử dụng theo các luồng tìm xe, đăng bán, quản lý tin, đặt cọc và điều khoản; liên kết trực tiếp tới từng chức năng.
- Cá nhân đăng nhập qua VNeID theo giao diện; tích hợp xác thực chính thức cần backend/đối tác VNeID và hiện chưa hoạt động trong prototype. Không có đăng nhập demo thay thế.
- Tài khoản doanh nghiệp chỉ do quản trị viên tạo trong CMS sau khi đối chiếu giấy phép kinh doanh, mã số thuế, tài khoản ngân hàng và giấy tờ người đại diện; prototype lưu thông tin văn bản/checklist trong trình duyệt, không lưu ảnh giấy tờ hay mật khẩu.
- Wizard đăng tin 5 bước, validation, lưu nháp, xem trước, gửi kiểm duyệt và quản lý tin.
- Trang đặt cọc/giao dịch có trạng thái minh họa, trung tâm trợ giúp và các trạng thái lỗi.
- Checkout đặt cọc có tóm tắt xe, chọn chuyển khoản/QR demo, xác nhận điều khoản và biên nhận `Pending Payment`; không xử lý tiền hoặc tự xác nhận `Paid`.
- CMS Đặt cọc hỗ trợ nhận chứng từ (`Pending Payment` → `Verifying`), xác nhận đã đối soát với mã tham chiếu (`Verifying` → `Paid`), ghi lịch sử thao tác và gửi thông báo demo tới mục Thông báo của người mua.
- Trang Điều khoản & Quy định công khai gồm điều khoản thành viên, nội quy sử dụng và miễn trừ trách nhiệm đặt cọc; CMS Legal cho phép biên tập nội dung, lưu nháp và xuất bản.

## Khu vực CMS

- Dashboard với KPI, biểu đồ và hoạt động gần đây.
- Quản lý tin, kiểm duyệt, người dùng, xác minh, đặt cọc, showroom, nội dung, media, menu, SEO, tags, thông báo, chiến dịch và analytics.
- Các phân hệ cấu hình gồm vai trò/quyền, bảo mật, tích hợp, audit log, hỗ trợ, pháp lý, từ khóa, retention và cấu hình hệ thống.
- Banner & slide cho phép tạo/sửa/xóa, bật/tắt, đổi thứ tự và cấu hình tiêu đề, mô tả, ảnh/video, link đích, nhãn CTA, thời lượng và tự chuyển slide trên homepage.
- Vị trí quảng cáo quản lý các slot homepage giữa nội dung/trước footer, in-feed trong kết quả tìm kiếm và sidebar trang chi tiết xe; mỗi slot có creative, link, trạng thái và trang preview tương ứng.
- CMS hiển thị khuyến nghị ảnh riêng theo từng slot: kích thước pixel, tỷ lệ khung, định dạng nên dùng, dung lượng tối đa và lưu ý crop trên mobile.
- Thư viện media và trang Nội dung có bảng hướng dẫn riêng cho ảnh cover/ảnh trong bài/ảnh chia sẻ; wizard đăng xe hiển thị chuẩn ảnh đại diện/gallery xe. Chuẩn logo showroom cũng có trong bảng Media Library.
- Automotive Catalog có các tab hãng, dòng xe, thế hệ, phiên bản, thuộc tính, địa giới, chất lượng, lịch sử và SEO; hiển thị đủ 57 nhóm Catalog theo đặc tả.
- Tìm kiếm bảng/Catalog, trạng thái, thao tác duyệt/sửa mẫu, modal tạo bản ghi, xuất CSV và tải mẫu Catalog.

## Dữ liệu và giới hạn

- Xe đã lưu, tin nháp và tin gửi duyệt dùng `localStorage` cho mục đích demo trên trình duyệt hiện tại.
- Banner được lưu trong `localStorage`; upload file demo giới hạn 700 KB/slide. Media production nên dùng CDN/object storage và backend quản lý upload.
- Cấu hình vị trí quảng cáo lưu trong `localStorage`; impression/click tracking và phân phối chiến dịch production cần backend.
- Trạng thái CMS đặt cọc, audit và thông báo chỉ mô phỏng trên trình duyệt; xác minh tiền thật cần backend/cổng thanh toán và quyền quản trị phù hợp.
- Văn bản pháp lý trong prototype chỉ là bản mẫu, cần pháp chế/luật sư rà soát và xác định pháp nhân, ngày hiệu lực, điều kiện hoàn cọc, tranh chấp trước production.
- Các biểu mẫu đăng nhập/OTP, liên hệ, xác minh, thanh toán, phân quyền và audit không kết nối dịch vụ thật.
- Không nhập thông tin cá nhân nhạy cảm thật. Không có API key, token hoặc dữ liệu giấy tờ trong frontend.
- Trạng thái giao dịch không thể được xác nhận là `Paid` từ thao tác người dùng; cần backend xác minh từ cổng thanh toán.
- Ảnh xe lấy từ Unsplash và font từ Google Fonts, do đó cần kết nối Internet để tải đầy đủ tài nguyên hình ảnh/font.

## Tệp

- `index.html`: điểm vào ứng dụng.
- `styles.css`: design tokens, giao diện responsive và component styles.
- `app.js`: điều hướng hash, dữ liệu mẫu và tương tác mock.
- `DESIGN.md`: đặc tả sản phẩm nguồn.
