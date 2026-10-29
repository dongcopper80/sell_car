Dưới đây là bản tổng hợp cuối cùng cho dự án Aoto.com.vn — nền tảng mua bán ô tô trực tuyến và hệ thống CMS quản trị, hợp nhất toàn bộ yêu cầu website, đăng tin, tìm kiếm, giao dịch đặt cọc, hồ sơ người bán, quản trị nội dung, phân hệ danh mục ô tô, quản lý địa giới hành chính, bảo mật và phân tích dữ liệu.

Tài liệu được tổ chức theo hướng có thể dùng làm đặc tả sản phẩm (Product Specification), cơ sở thiết kế UI/UX, đặc tả chức năng và đầu vào để yêu cầu AI sinh prototype HTML/CSS/JavaScript. Những nội dung liên quan đến thanh toán, xác minh người bán và bảo vệ dữ liệu được tách riêng để tránh thiết kế giao diện vượt quá khả năng thực tế của backend.

# Aoto.com.vn

Automotive Marketplace & Content Management System

Website người dùng

# 20

Nhóm màn hình và trạng thái giao diện

CMS quản trị

# 28

Phân hệ quản trị nghiệp vụ

Automotive Catalog

# 57

Nhóm màn hình/quản lý danh mục

Thiết kế theo phân quyền

# RBAC

Kèm kiểm soát quyền theo nghiệp vụ

Lưu ý: các con số trên là số lượng nhóm màn hình/phân hệ theo đặc tả đã xây dựng, không phải số URL, API hay bảng cơ sở dữ liệu cuối cùng. Một phân hệ có thể bao gồm nhiều màn hình thêm, sửa, xem chi tiết và xác nhận.

# 1. Mục tiêu sản phẩm

## 1.1. Định vị

Aoto.com.vn là nền tảng kết nối người mua và người bán ô tô, hỗ trợ cả người bán cá nhân lẫn showroom/salon. Website tập trung vào việc tìm kiếm xe phù hợp, trình bày thông tin xe rõ ràng, hỗ trợ người bán quản lý tin đăng và cung cấp công cụ vận hành cho đội ngũ quản trị.

Hệ thống gồm hai sản phẩm giao tiếp với nhau:

- Public Website: phục vụ người mua, người bán, khách chưa đăng nhập và người dùng đã đăng nhập.
- Admin CMS: quản lý tin đăng, người dùng, danh mục xe, nội dung website, giao dịch, thông báo, dữ liệu thống kê và cấu hình hệ thống.

CMS là hệ thống vận hành nghiệp vụ, không chỉ là công cụ sửa bài viết. Phân hệ danh mục ô tô phải đóng vai trò nền tảng dữ liệu dùng chung cho đăng tin, tìm kiếm, lọc, trang chi tiết và SEO.

## 1.2. Mục tiêu kinh doanh

1. Giúp người mua tìm được xe theo hãng, dòng xe, đời xe, giá, vị trí và thông số kỹ thuật.
2. Giúp người bán tạo và quản lý tin đăng thuận tiện.
3. Chuẩn hóa dữ liệu xe để tránh trùng tên, sai phiên bản và bộ lọc thiếu nhất quán.
4. Tạo cơ chế kiểm duyệt tin, báo cáo vi phạm và quản lý chất lượng nội dung.
5. Hỗ trợ giao dịch đặt cọc theo quy trình có trạng thái và bằng chứng giao dịch rõ ràng.
6. Tăng khả năng tìm kiếm tự nhiên thông qua SEO, trang danh mục và nội dung.
7. Cung cấp dashboard cho quản trị viên theo dõi hoạt động toàn nền tảng.

## 1.3. Phạm vi bản MVP

MVP nên ưu tiên luồng sử dụng hoàn chỉnh thay vì xây dựng tất cả phân hệ ở mức độ phức tạp cao ngay từ đầu.

| Nhóm      | Phạm vi ưu tiên                                                              |
| --------- | ---------------------------------------------------------------------------- |
| Website   | Trang chủ, tìm kiếm, danh sách xe, chi tiết xe, hồ sơ người bán              |
| Tài khoản | Đăng ký, đăng nhập, OTP, hồ sơ cá nhân                                       |
| Tin đăng  | Đăng tin theo wizard, xem trước, quản lý tin, kiểm duyệt                     |
| Danh mục  | Hãng xe, dòng xe, đời xe, phiên bản, loại xe, nhiên liệu, hộp số, tỉnh/thành |
| Giao dịch | Mô hình đặt cọc, trạng thái giao dịch, lịch sử và đối soát                   |
| CMS       | Dashboard, người dùng, tin đăng, danh mục, nội dung, media, cấu hình         |
| An toàn   | RBAC, audit log, giới hạn OTP, kiểm soát truy cập dữ liệu cá nhân            |
| Analytics | Thống kê người dùng, tin đăng, lượt xem, tìm kiếm và giao dịch               |

Các chức năng nâng cao như đề xuất xe bằng AI, đồng bộ dữ liệu từ nhiều nguồn, quản lý showroom đa chi nhánh, đối soát tài chính tự động và cá nhân hóa nâng cao nên được triển khai sau khi luồng MVP hoạt động ổn định.

# 2. Kiến trúc tổng thể sản phẩm

Người dùng

Người mua · Người bán cá nhân · Salon · Quản trị viên

Public Website

Responsive UI · SEO · Tìm kiếm · Đăng tin

Admin CMS

Quản trị · Kiểm duyệt · Danh mục · Analytics

Application / API Layer

Authentication · Authorization · Business Rules · Validation · Audit

Database

Người dùng, xe, tin đăng, giao dịch

Media Storage

Ảnh xe, tài liệu, nội dung

Search / Cache

Tìm kiếm, bộ lọc, dữ liệu đọc nhiều

Payment Integration

Cổng thanh toán, webhook, đối soát

Đây là kiến trúc logic, không bắt buộc phải triển khai thành nhiều microservice ngay từ đầu. Với MVP, có thể bắt đầu bằng một backend modular monolith có phân tách module rõ ràng, sau đó tách dịch vụ khi có nhu cầu về tải, vận hành hoặc đội ngũ.

# 3. Đặc tả Public Website

## 3.1. Danh sách màn hình

| Mã     | Màn hình            | Chức năng chính                                                         |
| ------ | ------------------- | ----------------------------------------------------------------------- |
| WEB-01 | Homepage            | Banner, tìm kiếm nhanh, xe mới đăng, xe nổi bật, hãng xe, nội dung SEO  |
| WEB-02 | Listing Page        | Danh sách xe, sắp xếp, phân trang, số lượng kết quả                     |
| WEB-03 | Advanced Search     | Bộ lọc nâng cao theo giá, hãng, model, năm, vị trí, loại xe và thông số |
| WEB-04 | Vehicle Detail      | Ảnh xe, thông số, mô tả, giá, người bán, lịch sử và xe tương tự         |
| WEB-05 | Seller Profile      | Hồ sơ người bán, xe đang bán, thông tin xác minh và đánh giá nếu có     |
| WEB-06 | Sign Up             | Đăng ký tài khoản, điều khoản sử dụng                                   |
| WEB-07 | Login / OTP         | Đăng nhập, xác minh OTP, gửi lại mã, xử lý giới hạn thử                 |
| WEB-08 | Post Listing Wizard | Đăng tin nhiều bước, lưu nháp, kiểm tra dữ liệu                         |
| WEB-09 | Listing Preview     | Xem trước tin trước khi gửi duyệt                                       |
| WEB-10 | My Listings         | Danh sách tin, trạng thái, sửa, ẩn, đánh dấu đã bán                     |
| WEB-11 | Saved Vehicles      | Xe đã lưu, bỏ lưu, truy cập chi tiết                                    |
| WEB-12 | My Profile          | Hồ sơ cá nhân, liên hệ, bảo mật tài khoản                               |
| WEB-13 | Notifications       | Thông báo tin đăng, giao dịch, hệ thống                                 |
| WEB-14 | Vehicle Alerts      | Lưu tiêu chí tìm kiếm và nhận thông báo xe phù hợp                      |
| WEB-15 | Deposit             | Khởi tạo và theo dõi yêu cầu đặt cọc                                    |
| WEB-16 | Transactions        | Lịch sử giao dịch, trạng thái và thông tin liên quan                    |
| WEB-17 | Salon Profile       | Hồ sơ showroom, địa chỉ, xe đang bán                                    |
| WEB-18 | Help / Policies     | Hướng dẫn, câu hỏi thường gặp, chính sách và điều khoản                 |
| WEB-19 | Error States        | 404, 403, 500, hết hạn, không có kết quả, lỗi mạng                      |
| WEB-20 | Footer / Global UI  | Footer, menu, popup, cookie/consent nếu áp dụng                         |

Một số màn hình trên có thể triển khai dưới dạng tab hoặc trang con, không nhất thiết phải tạo thành 20 route độc lập.

## 3.2. Homepage

Các khu vực nên có theo thứ tự ưu tiên:

1. Header: logo, menu, ô tìm kiếm, đăng nhập và nút đăng tin.
2. Hero section: hình ảnh chủ đạo và tìm kiếm xe nhanh.
3. Bộ lọc nhanh: hãng xe, khoảng giá, loại xe, tỉnh/thành.
4. Xe mới đăng.
5. Xe nổi bật hoặc tin được tài trợ.
6. Danh mục theo hãng, loại xe, mức giá.
7. Khu vực xe tại các tỉnh/thành.
8. Nội dung tư vấn mua xe và kiến thức ô tô.
9. Khu vực dành cho showroom/người bán.
10. Footer gồm liên kết, chính sách, thông tin liên hệ và nội dung pháp lý.

Banner, xe nổi bật và các khối nội dung nên có thể quản trị từ CMS. Không hard-code nội dung sản phẩm vào HTML.

## 3.3. Trang danh sách và tìm kiếm xe

Bộ lọc cơ bản:

- Hãng xe, dòng xe, thế hệ, phiên bản.
- Khoảng giá.
- Năm sản xuất.
- Tỉnh/thành và khu vực.
- Tình trạng xe: mới hoặc đã qua sử dụng.
- Loại thân xe.
- Nhiên liệu, hộp số, hệ dẫn động.
- Số chỗ ngồi.
- Số km đã đi.
- Người bán cá nhân hoặc salon.
- Tin đã xác minh, nếu nền tảng có quy trình xác minh thực sự.

Các bộ lọc nâng cao có thể bổ sung dung tích động cơ, công suất, màu sắc, tiêu hao nhiên liệu, thông số pin xe điện và trang bị an toàn.

Quy tắc quan trọng: bộ lọc trên Website phải được cấu hình dựa trên danh mục và thuộc tính có trong Catalog. Không tạo một bộ lọc riêng chỉ tồn tại ở frontend mà không có mô hình dữ liệu tương ứng.

Cần hỗ trợ:

- Kết hợp nhiều điều kiện lọc.
- Hiển thị các điều kiện đã chọn và cho phép xóa từng điều kiện.
- Lưu bộ lọc trên URL để chia sẻ và hỗ trợ SEO khi phù hợp.
- Sắp xếp theo mới nhất, giá tăng dần, giá giảm dần.
- Trạng thái loading, không có kết quả và lỗi truy vấn.
- Responsive: sidebar trên desktop, drawer hoặc bottom sheet trên mobile.

## 3.4. Trang chi tiết xe

[CarPrice Market Car Details by Paul Matvienko on Dribbble](https://images.openai.com/static-rsc-4/dU5dxdulHDfZX9LU6DUgX-M0n5I_qA0nn1C5JfJqyXJA0nnd-odF-4aHjFebbspZUskX6RKfPYWktX2ydf2D4Q5U9_t2ikgAZqtt9-NHpuimsdh8F-VyPfRtgGnElOPUYWlreBYM9bIq9CfnLiIORA87Kl8D7W-FmuTCm2DAq9Q?purpose=inline)

[dribbble.com](https://dribbble.com/shots/20622250-CarPrice-Market-Car-Details?utm_source=chatgpt.com)

Hình tham khảo phong cách bố cục; không phải giao diện chính thức của Aoto.com.vn.

### Cấu trúc thông tin

1. Gallery ảnh, ảnh bìa, ảnh bổ sung và video nếu hỗ trợ.
2. Tiêu đề xe, giá bán, vị trí, thời gian đăng và trạng thái tin.
3. Thông số: hãng, model, năm, phiên bản, số km, nhiên liệu, hộp số, số chỗ.
4. Mô tả, tình trạng xe, lịch sử va chạm/ngập nước nếu người bán cung cấp.
5. Thông tin người bán, loại người bán và trạng thái xác minh.
6. Nút lưu xe, chia sẻ, báo cáo tin và liên hệ người bán.
7. Xe tương tự, tin cùng hãng hoặc cùng khu vực.

Số điện thoại và thông tin liên hệ cần tuân theo chính sách hiển thị và quyền truy cập đã xác định. Không nên coi việc người dùng đăng nhập hoặc đặt cọc là căn cứ mặc định để mở toàn bộ dữ liệu cá nhân của người bán.

## 3.5. Đăng tin xe

Thiết kế dạng wizard, chia thành các bước để người dùng dễ hoàn thành:

| Bước | Nội dung                                                  |
| ---- | --------------------------------------------------------- |
| 1    | Loại xe, hãng, dòng xe, thế hệ, phiên bản                 |
| 2    | Năm sản xuất, số km, nhiên liệu, hộp số, thông số thực tế |
| 3    | Giá bán, tình trạng xe, thông tin lịch sử                 |
| 4    | Tỉnh/thành, địa chỉ hiển thị, hình thức người bán         |
| 5    | Tải ảnh, chọn ảnh bìa, sắp xếp ảnh                        |
| 6    | Tiêu đề, mô tả và thông tin liên hệ được phép hiển thị    |
| 7    | Xem trước, xác nhận và gửi kiểm duyệt                     |

Yêu cầu tương tác:

- Lưu nháp tự động hoặc có nút lưu nháp.
- Quay lại bước trước mà không mất dữ liệu.
- Validation ngay tại trường và validation tổng trước khi gửi.
- Hiển thị tiến độ hoàn thành.
- Cho phép tải lên nhiều ảnh, xem trước và xóa ảnh.
- Không cho phép gửi duyệt khi thiếu các trường bắt buộc.
- Hiển thị kết quả gửi tin và trạng thái hiện tại.

Thông tin cấu hình chuẩn của xe cần tách biệt với thông tin thực tế của chiếc xe đang rao bán. Ví dụ, dung tích động cơ chuẩn của một phiên bản không nhất thiết chứng minh chiếc xe thực tế còn nguyên trạng hoặc đúng thông số.

# 4. Đặc tả CMS quản trị

## 4.1. Danh sách 28 phân hệ

| Mã     | Phân hệ                            | Chức năng                                               |
| ------ | ---------------------------------- | ------------------------------------------------------- |
| CMS-01 | Dashboard                          | KPI, biểu đồ, hoạt động gần đây                         |
| CMS-02 | Admin Users & Roles                | Tài khoản quản trị, role và permission                  |
| CMS-03 | User Management                    | Người mua, người bán, trạng thái tài khoản              |
| CMS-04 | Identity / Company Verification    | Xác minh cá nhân, showroom và hồ sơ liên quan           |
| CMS-05 | Listing Management                 | Danh sách tin, sửa, duyệt, từ chối, ẩn, hết hạn         |
| CMS-06 | Moderation & Reports               | Báo cáo vi phạm, xử lý nội dung, lịch sử quyết định     |
| CMS-07 | Automotive Catalog                 | Hãng, model, thế hệ, phiên bản, thuộc tính xe           |
| CMS-08 | Vehicle Attribute Management       | Định nghĩa thuộc tính, kiểu dữ liệu, đơn vị và quy tắc  |
| CMS-09 | Deposit Management                 | Yêu cầu đặt cọc, trạng thái và hồ sơ đối soát           |
| CMS-10 | Salon Management                   | Showroom, chi nhánh, địa chỉ và hồ sơ                   |
| CMS-11 | Content Management                 | Bài viết, trang tĩnh, hướng dẫn, nội dung SEO           |
| CMS-12 | Media Library                      | Ảnh, tệp, metadata, tìm kiếm và quản lý sử dụng         |
| CMS-13 | Menu Management                    | Menu header, footer và menu phân cấp                    |
| CMS-14 | SEO Management                     | Title, description, canonical, robots và cấu hình SEO   |
| CMS-15 | Tag Management                     | Tags, alias và liên kết nội dung                        |
| CMS-16 | Notification Management            | Mẫu và lịch sử thông báo                                |
| CMS-17 | Campaign Management                | Chiến dịch quảng bá, banner và tin nổi bật              |
| CMS-18 | Analytics & Reports                | Báo cáo người dùng, tin, lượt xem, giao dịch            |
| CMS-19 | System Configuration               | Cấu hình website, upload, giới hạn và tính năng         |
| CMS-20 | Script / Integration Configuration | Quản lý tích hợp và mã tracking theo allowlist          |
| CMS-21 | Audit Log                          | Nhật ký thay đổi và thao tác nhạy cảm                   |
| CMS-22 | Support / Customer Service         | Yêu cầu hỗ trợ và xử lý khiếu nại                       |
| CMS-23 | Legal Content                      | Điều khoản, chính sách bảo mật và quy định giao dịch    |
| CMS-24 | Search Keywords                    | Từ khóa tìm kiếm, từ khóa phổ biến và từ đồng nghĩa     |
| CMS-25 | Archive / Retention                | Lưu trữ, hết hạn và chính sách vòng đời dữ liệu         |
| CMS-26 | Notification Templates             | Mẫu email, SMS, OTP hoặc thông báo trong ứng dụng       |
| CMS-27 | Security Management                | Phiên đăng nhập, chính sách bảo mật và sự kiện đáng ngờ |
| CMS-28 | Catalog Import / Export            | Nhập/xuất danh mục, validation và báo cáo lỗi           |

CMS-07 và CMS-08 quản lý dữ liệu danh mục; CMS-28 cung cấp công cụ nhập/xuất dữ liệu. Không nên xây dựng ba kho dữ liệu độc lập cho cùng một thông tin.

## 4.2. Bố cục CMS dùng chung

Sidebar

Điều hướng theo module

Tìm kiếm dữ liệu...

### Tên màn hình / Breadcrumb

Tổng số

## 1.250

Đang hoạt động

## 980

Cần xử lý

## 18

Bộ lọc · Trạng thái · Ngày tạo

Thêm mới

Mã

Tên

Trạng thái

001

Dữ liệu mẫu

Active

002

Dữ liệu mẫu

Draft

Minh họa cấu trúc quản trị. Số liệu và bản ghi chỉ là dữ liệu mẫu, không phải dữ liệu vận hành thực tế.

Mỗi màn hình quản trị nên thống nhất các thành phần:

- Breadcrumb và tiêu đề.
- Mô tả mục đích màn hình.
- KPI khi thực sự hữu ích.
- Tìm kiếm, bộ lọc và nút thao tác.
- Bảng dữ liệu, phân trang và chọn nhiều bản ghi.
- Drawer hoặc form thêm/sửa.
- Trang chi tiết hoặc tab thông tin liên quan.
- Xác nhận thao tác nguy hiểm.
- Trạng thái loading, empty, error, success.
- Phân quyền hiển thị và thực thi thao tác.

## 4.3. Quản lý tin đăng trong CMS

Admin cần có khả năng:

- Tìm theo mã tin, người bán, hãng/model và thời gian.
- Lọc theo trạng thái, tỉnh/thành, loại người bán.
- Xem chi tiết tin và ảnh.
- Duyệt, từ chối kèm lý do, yêu cầu bổ sung, ẩn hoặc xử lý vi phạm.
- Xem lịch sử thay đổi.
- Theo dõi tin hết hạn, tin đã bán và tin bị báo cáo.
- Thực hiện thao tác hàng loạt trong giới hạn quyền được cấp.

Không nên cho phép admin chỉnh sửa dữ liệu mà không lưu dấu vết. Các thao tác như duyệt tin, thay đổi giá do quản trị can thiệp, xử lý báo cáo và khóa tài khoản phải có audit log.

# 5. Automotive Catalog Management — phân hệ trọng tâm

Đây là một trong những phần quan trọng nhất của hệ thống vì dữ liệu catalog quyết định chất lượng đăng tin, tìm kiếm, bộ lọc, trang chi tiết và các trang SEO.

## 5.1. Mô hình dữ liệu phân cấp

Vehicle Type

Loại xe

Make

Hãng xe

Model

Dòng xe

Generation

Thế hệ / khoảng năm áp dụng

Trim / Version

Phiên bản xe

Vehicle Configuration

Thông số kỹ thuật chuẩn

Một số quan hệ thực tế có thể nhiều-nhiều hoặc không xác định đầy đủ. Không nên ép tất cả thuộc tính vào một cây phân cấp.

Ví dụ minh họa: Toyota → Camry → một thế hệ cụ thể → phiên bản 2.5Q → bộ thông số kỹ thuật tương ứng.

Các nhóm như nhiên liệu, hộp số, màu sắc, tính năng, tiêu chuẩn khí thải và xuất xứ phải được thiết kế thành danh mục tham chiếu hoặc thuộc tính liên kết. Không nên coi chúng là các node con bắt buộc của cây hãng xe.

## 5.2. Danh mục 57 nhóm quản trị

Các nhóm sau được hợp nhất từ yêu cầu catalog ban đầu. Chúng là danh mục thiết kế màn hình/nghiệp vụ, không phải yêu cầu phải tạo 57 bảng dữ liệu độc lập.

| Mã     | Nhóm quản lý                 | Nội dung                               |
| ------ | ---------------------------- | -------------------------------------- |
| CAT-01 | Catalog Dashboard            | Thống kê và chất lượng dữ liệu         |
| CAT-02 | Vehicle Types                | Loại xe                                |
| CAT-03 | Vehicle Segments             | Phân khúc xe                           |
| CAT-04 | Use Purposes                 | Mục đích sử dụng                       |
| CAT-05 | Makes                        | Hãng xe                                |
| CAT-06 | Make Origins                 | Quốc gia xuất xứ hãng                  |
| CAT-07 | Models                       | Dòng xe                                |
| CAT-08 | Generations                  | Thế hệ xe                              |
| CAT-09 | Trims                        | Phiên bản xe                           |
| CAT-10 | Production Years             | Năm sản xuất                           |
| CAT-11 | Variants                     | Biến thể xe                            |
| CAT-12 | Model Aliases                | Tên gọi khác của model                 |
| CAT-13 | Body Types                   | Kiểu thân xe                           |
| CAT-14 | Engine Types                 | Loại động cơ                           |
| CAT-15 | Fuel / Energy Types          | Nhiên liệu và năng lượng               |
| CAT-16 | Engine Displacement          | Dung tích động cơ                      |
| CAT-17 | Power / Torque               | Công suất và mô-men xoắn               |
| CAT-18 | Transmissions                | Hộp số                                 |
| CAT-19 | Drivetrains                  | Hệ dẫn động                            |
| CAT-20 | Seat Counts                  | Số chỗ ngồi                            |
| CAT-21 | Door Counts                  | Số cửa                                 |
| CAT-22 | Exterior Colors              | Màu ngoại thất                         |
| CAT-23 | Interior Colors              | Màu nội thất                           |
| CAT-24 | Dimensions                   | Kích thước xe                          |
| CAT-25 | Fuel Consumption             | Mức tiêu hao nhiên liệu                |
| CAT-26 | EV Battery Specs             | Thông số pin xe điện                   |
| CAT-27 | Equipment / Safety Features  | Trang bị và tính năng an toàn          |
| CAT-28 | Emission Standards           | Tiêu chuẩn khí thải                    |
| CAT-29 | Inspection States            | Tình trạng đăng kiểm                   |
| CAT-30 | Measurement Units            | Đơn vị đo                              |
| CAT-31 | Countries                    | Quốc gia                               |
| CAT-32 | Province / City              | Tỉnh/thành                             |
| CAT-33 | Ward / Commune               | Phường/xã                              |
| CAT-34 | Display Areas                | Khu vực hiển thị                       |
| CAT-35 | Salon Addresses              | Địa chỉ salon                          |
| CAT-36 | Delivery / Transaction Areas | Khu vực giao nhận                      |
| CAT-37 | Vehicle Conditions           | Tình trạng xe                          |
| CAT-38 | Engine Conditions            | Tình trạng động cơ                     |
| CAT-39 | Transmission Conditions      | Tình trạng hộp số                      |
| CAT-40 | Accident History             | Lịch sử tai nạn                        |
| CAT-41 | Flood History                | Lịch sử ngập nước                      |
| CAT-42 | Airbag Status                | Tình trạng túi khí                     |
| CAT-43 | Inspection Status            | Trạng thái kiểm định                   |
| CAT-44 | Document Types               | Loại giấy tờ                           |
| CAT-45 | Vehicle Verification Status  | Trạng thái xác minh xe                 |
| CAT-46 | Warranty Policies            | Chính sách bảo hành                    |
| CAT-47 | Extensible Attributes        | Thuộc tính mở rộng                     |
| CAT-48 | Attribute Sets               | Bộ thuộc tính theo loại xe             |
| CAT-49 | Search Filter Configuration  | Cấu hình bộ lọc                        |
| CAT-50 | Trim / Specification Mapping | Ánh xạ phiên bản và thông số           |
| CAT-51 | Alias Management             | Quản lý alias/từ đồng nghĩa            |
| CAT-52 | Catalog Import               | Nhập CSV/XLSX                          |
| CAT-53 | Catalog Export               | Xuất dữ liệu                           |
| CAT-54 | Data Quality                 | Kiểm tra chất lượng dữ liệu            |
| CAT-55 | Catalog Change History       | Lịch sử thay đổi                       |
| CAT-56 | Catalog SEO                  | Metadata và URL SEO                    |
| CAT-57 | Catalog Status               | Trạng thái, kích hoạt và ngừng sử dụng |

### Phân biệt các nhóm dễ trùng lặp

- CAT-12 và CAT-51: CAT-12 là alias ở phạm vi model; CAT-51 là công cụ quản lý alias dùng chung cho nhiều loại thực thể.
- CAT-27 và CAT-47: CAT-27 quản lý danh mục trang bị/tính năng; CAT-47 cho phép định nghĩa thêm thuộc tính chưa có trong schema cố định.
- CAT-29 và CAT-43: CAT-29 có thể quản lý danh mục tình trạng/loại kiểm định; CAT-43 quản lý trạng thái kiểm định của một chiếc xe hoặc hồ sơ cụ thể. Hai nhóm chỉ nên tách nếu nghiệp vụ thực sự cần.
- CAT-32 và CAT-33: tỉnh/thành và phường/xã là dữ liệu địa giới có quan hệ cha-con và cần phiên bản hóa khi có thay đổi hành chính.
- CAT-10 và CAT-08: năm sản xuất và thế hệ xe có liên quan nhưng không đồng nhất; một thế hệ có thể trải qua nhiều năm sản xuất.

## 5.3. Màn hình danh sách model

Các thành phần:

- Tìm kiếm theo tên, slug, mã và alias.
- Bộ lọc hãng, loại xe, trạng thái và khoảng năm.
- Bảng model gồm mã, tên, hãng, loại xe, số thế hệ, số phiên bản, trạng thái.
- Nút thêm mới, sửa, xem chi tiết, nhân bản và ngừng sử dụng.
- Phân trang, sắp xếp và chọn nhiều bản ghi.
- Kiểm tra trùng tên/slug trong phạm vi hãng.
- Hiển thị cảnh báo khi model đang được tham chiếu bởi tin đăng hoặc phiên bản.

## 5.4. Form cấu hình phiên bản xe

Nên chia thành các tab:

1. General: mã, tên phiên bản, model, generation, năm áp dụng.
2. Engine: loại động cơ, dung tích, công suất, mô-men xoắn.
3. Transmission: hộp số, hệ dẫn động.
4. Dimensions: dài, rộng, cao, chiều dài cơ sở, trọng lượng.
5. Operation: nhiên liệu, mức tiêu hao, số chỗ, số cửa.
6. EV / Battery: dung lượng pin, loại pin, công suất sạc và thông số liên quan.
7. Features: trang bị, an toàn, tiện nghi.
8. Data Sources: nguồn dữ liệu, mức độ tin cậy, thời điểm cập nhật, người xác nhận.
9. SEO / Aliases: slug, tên gọi khác, metadata nếu phiên bản có trang SEO riêng.

Không phải phiên bản nào cũng có tất cả thuộc tính. Form phải hiển thị trường theo loại xe, loại năng lượng và bộ thuộc tính đã cấu hình.

# 6. Thiết kế cơ sở dữ liệu

## 6.1. Nguyên tắc thiết kế

- Dùng khóa chính ổn định, ưu tiên UUID cho các thực thể nghiệp vụ.
- Phân biệt dữ liệu danh mục chuẩn với dữ liệu thực tế do người bán nhập.
- Có `created_at`, `updated_at`, `created_by`, `updated_by` cho các bảng cần truy vết.
- Có `status` hoặc `is_active` khi nghiệp vụ cần ngừng sử dụng mà không xóa dữ liệu lịch sử.
- Dùng foreign key và unique constraint cho các quan hệ quan trọng.
- Có audit log cho thao tác quản trị nhạy cảm.
- Có cơ chế import/export và phát hiện bản ghi trùng.
- Không lưu giấy tờ nhạy cảm như tệp công khai trong media library.

## 6.2. Các nhóm bảng chính

| Nhóm               | Bảng/nhóm bảng đề xuất                                                                                                                                    |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Identity           | `users`, `user_profiles`, `user_sessions`, `roles`, `permissions`, `user_roles`, `role_permissions`                                                       |
| Seller / Salon     | `seller_profiles`, `salons`, `salon_branches`, `seller_verifications`                                                                                     |
| Catalog            | `vehicle_types`, `vehicle_segments`, `vehicle_makes`, `vehicle_models`, `vehicle_generations`, `vehicle_trims`, `vehicle_configurations`                  |
| Vehicle Attributes | `vehicle_attribute_definitions`, `vehicle_attribute_options`, `vehicle_configuration_attributes`                                                          |
| Reference Data     | `vehicle_body_types`, `vehicle_fuel_types`, `vehicle_transmissions`, `vehicle_drivetrains`, `vehicle_colors`, `vehicle_features`, `vehicle_trim_features` |
| Aliases            | `vehicle_make_aliases`, `vehicle_model_aliases`, hoặc một mô hình alias tổng quát                                                                         |
| Geography          | `countries`, `administrative_divisions`                                                                                                                   |
| Listings           | `vehicle_listings`, `listing_photos`, `listing_status_history`, `listing_reports`                                                                         |
| Search / Saved     | `saved_vehicles`, `saved_searches`, `search_events`, `vehicle_views`                                                                                      |
| Transactions       | `deposit_transactions`, `payment_events`, `refund_requests`, `transaction_audit_logs`                                                                     |
| Content            | `content_pages`, `articles`, `media_assets`, `menus`, `menu_items`, `tags`, `content_tags`                                                                |
| SEO                | `seo_metadata`, `redirect_rules`, `canonical_rules`                                                                                                       |
| Notifications      | `notifications`, `notification_templates`, `notification_deliveries`                                                                                      |
| CMS                | `admin_users` nếu tách riêng, `audit_logs`, `system_settings`, `feature_flags`                                                                            |
| Import / Quality   | `catalog_import_jobs`, `catalog_import_rows`, `catalog_audit_logs`, `data_quality_issues`                                                                 |
| Analytics          | `analytics_events`, các bảng tổng hợp theo ngày/tháng                                                                                                     |

Tên bảng là đề xuất logic. Schema cuối cùng cần được điều chỉnh theo database được chọn, framework backend, yêu cầu truy vấn và chính sách lưu trữ.

## 6.3. Phân biệt Catalog và Listing

Ví dụ về hai loại dữ liệu:

Catalog — dữ liệu chuẩn của phiên bản

- Hãng: Toyota.
- Model: Camry.
- Thế hệ: một thế hệ cụ thể.
- Phiên bản: 2.5Q.
- Hộp số, nhiên liệu, dung tích động cơ, công suất chuẩn.
- Nguồn tham chiếu và thời điểm xác nhận thông số.

Listing — dữ liệu của chiếc xe đang bán

- Giá bán thực tế.
- Năm đăng ký hoặc năm sản xuất được người bán khai báo.
- Số km đã đi.
- Màu xe thực tế.
- Tình trạng hiện tại.
- Lịch sử tai nạn/ngập nước được khai báo.
- Hình ảnh xe.
- Người bán và địa điểm.
- Trạng thái kiểm duyệt tin.

Không nên ghi đè dữ liệu Catalog mỗi khi người bán tạo một tin đăng. Nếu thông số của một chiếc xe khác với cấu hình chuẩn, hệ thống cần phân biệt dữ liệu khai báo, dữ liệu xác minh và dữ liệu tham chiếu.

## 6.4. Mô hình thuộc tính mở rộng

Đối với các loại xe có thuộc tính khác nhau, có thể dùng mô hình metadata:

- `vehicle_attribute_definitions`: định nghĩa thuộc tính.
- `vehicle_attribute_options`: các giá trị lựa chọn.
- `vehicle_configuration_attributes`: giá trị thuộc tính theo cấu hình xe.
- `attribute_sets`: bộ thuộc tính theo loại xe.
- `attribute_set_items`: thuộc tính thuộc từng bộ.
- `search_filter_configs`: cấu hình thuộc tính nào được dùng làm bộ lọc.

Mỗi định nghĩa thuộc tính nên có:

- `code`, `name`, `description`.
- `data_type`: string, number, boolean, enum, date hoặc kiểu phù hợp.
- `unit`.
- `is_filterable`, `is_searchable`, `is_required`.
- Quy tắc validation, phạm vi áp dụng và trạng thái.

Không nên dùng một bảng key-value để thay thế toàn bộ cột quan trọng. Giá bán, năm, số km, trạng thái tin, thời gian tạo và các trường thường xuyên truy vấn nên được mô hình hóa rõ ràng.

## 6.5. Địa giới hành chính

Đề xuất sử dụng bảng `administrative_divisions` với các trường như:

- `id`, `code`, `name`, `level`.
- `parent_id`.
- `valid_from`, `valid_to` hoặc thông tin phiên bản dữ liệu.
- `status`, `source`, `updated_at`.

Cách này cho phép biểu diễn nhiều cấp địa giới và lưu lịch sử khi đơn vị hành chính thay đổi. Nếu cần tối ưu truy vấn, có thể bổ sung bảng riêng cho tỉnh/thành hoặc phường/xã.

Lưu ý: dữ liệu địa giới phải có nguồn chính thức và được cập nhật theo phiên bản. Không nên hard-code danh sách tỉnh/thành hoặc giả định mọi địa chỉ cũ luôn ánh xạ trực tiếp sang địa chỉ mới.

# 7. Quy trình nghiệp vụ và trạng thái

## 7.1. Quy trình tin đăng

Draft

Người bán đang soạn tin

Pending Review

Chờ kiểm duyệt

Approved

Active

Tin được hiển thị

Rejected

Yêu cầu chỉnh sửa

Có lý do từ chối

Reserved / Sold / Expired / Hidden / Violated

Các trạng thái tiếp theo theo nghiệp vụ

Bộ trạng thái đề xuất:

`Draft`, `Pending Review`, `Active`, `Reserved`, `Sold`, `Rejected`, `Violated`, `Expired`, `Hidden`.

Cần xác định rõ các chuyển trạng thái hợp lệ. Ví dụ, tin đã bán không nên tự động quay lại Active mà không có thao tác hoặc quy trình xác nhận phù hợp.

## 7.2. Quy trình đặt cọc

Đề xuất trạng thái:

`Pending Payment` → `Verifying` → `Paid`

Các nhánh khác gồm:

- `Failed`
- `Expired`
- `Refund Pending`
- `Refunded`
- `Disputed`

Các trạng thái cần phản ánh cả sự kiện từ cổng thanh toán lẫn quyết định nghiệp vụ. Giao diện không được tự đánh dấu Paid chỉ vì người dùng nhấn nút “Tôi đã thanh toán”.

Quy trình cần hỗ trợ:

1. Tạo yêu cầu đặt cọc và mã giao dịch.
2. Hiển thị số tiền, điều khoản và chính sách hoàn tiền.
3. Chuyển đến cổng thanh toán hoặc phương thức thanh toán được hỗ trợ.
4. Nhận callback/webhook từ nguồn đáng tin cậy.
5. Xác minh chữ ký, mã giao dịch, số tiền và tính duy nhất của sự kiện.
6. Cập nhật trạng thái giao dịch một cách idempotent.
7. Ghi log đối soát, gửi thông báo và xử lý sự cố.
8. Có quy trình xử lý hoàn tiền và tranh chấp.

Nếu đặt cọc 5.000.000 đồng là yêu cầu kinh doanh, số tiền này nên là cấu hình có phiên bản hoặc cấu hình theo loại giao dịch, không hard-code vào frontend. Trước khi đưa vào sản phẩm thật, cần xác định rõ bên nhận tiền, vai trò của nền tảng, điều kiện hoàn cọc, cơ chế tranh chấp và các nghĩa vụ pháp lý liên quan.

## 7.3. Xác minh người dùng và showroom

Trạng thái đề xuất:

`Not Submitted`, `Pending`, `Verified`, `Rejected`, `Expired`, `Revoked`.

Mỗi hồ sơ xác minh cần lưu:

- Chủ thể được xác minh.
- Loại hồ sơ và trạng thái.
- Thời gian nộp, người xử lý, thời gian xử lý.
- Lý do từ chối hoặc thu hồi.
- Metadata kiểm tra và dấu vết thao tác.

Tệp giấy tờ cần được bảo vệ bằng quyền truy cập riêng, thời hạn lưu giữ và cơ chế xóa phù hợp. Không hiển thị công khai tài liệu định danh hoặc thông tin nhạy cảm trong trang hồ sơ người bán.

# 8. Quy tắc bảo mật và vận hành

## 8.1. Authentication và Authorization

- Có RBAC cho người dùng quản trị.
- Kiểm tra quyền tại backend, không chỉ ẩn nút trên UI.
- Phân tách quyền xem, tạo, sửa, duyệt, xóa/ngừng sử dụng, xuất dữ liệu.
- Hỗ trợ khóa tài khoản, thu hồi phiên đăng nhập và audit log.
- Giới hạn OTP theo tài khoản, IP, thiết bị và thời gian.
- Có cơ chế chống dò tài khoản, brute force và lạm dụng endpoint.
- Không đưa access token, secret hoặc thông tin nhạy cảm vào mã frontend.

Có thể dùng chính sách khóa tạm sau 5 lần đăng nhập sai trong 5 phút như cấu hình khởi điểm, nhưng phải kết hợp rate limiting và biện pháp chống lạm dụng. Không nên chỉ dựa vào khóa theo IP vì có thể ảnh hưởng người dùng hợp lệ dùng chung mạng.

## 8.2. Bảo vệ dữ liệu và nội dung

- Kiểm tra loại tệp, kích thước và nội dung upload.
- Lưu file riêng biệt khỏi thư mục thực thi web.
- Phân quyền media theo mục đích sử dụng.
- Có thể tạo watermark phía server cho ảnh tin đăng.
- Escape nội dung người dùng và phòng chống XSS.
- Không cho phép người dùng chèn HTML/JavaScript tùy ý vào mô tả xe.
- Hạn chế việc chèn script tracking bằng allowlist, quyền đặc biệt và quy trình phê duyệt.
- Không lưu dữ liệu thẻ thanh toán nhạy cảm nếu không cần và không có cơ chế tuân thủ phù hợp.
- Có chính sách backup, phục hồi, retention và xử lý sự cố.

## 8.3. Audit và truy vết

Nên ghi nhận tối thiểu:

- Ai thực hiện hành động.
- Hành động gì, trên đối tượng nào.
- Thời gian và kết quả.
- Giá trị trước/sau đối với thay đổi quan trọng.
- Nguồn thao tác và correlation ID nếu có.

Không ghi mật khẩu, OTP, token hoặc dữ liệu nhạy cảm đầy đủ vào log. Quyền xem audit log cũng cần được giới hạn.

# 9. Thiết kế UI/UX và Design System

## 9.1. Định hướng giao diện

Public Website

- Phong cách marketplace ô tô hiện đại.
- Hình ảnh xe là nội dung chủ đạo.
- Thông tin giá, hãng, đời xe, vị trí và trạng thái dễ đọc.
- CTA rõ ràng: xem chi tiết, lưu xe, đăng tin, liên hệ.
- Ưu tiên mobile-first cho tìm kiếm và đăng tin.

Admin CMS

- Ưu tiên mật độ thông tin và hiệu quả công việc.
- Sidebar cố định, bảng dữ liệu dễ đọc.
- Bộ lọc rõ ràng, thao tác hàng loạt có kiểm soát.
- Form nhiều tab cho catalog phức tạp.
- Màu trạng thái thống nhất.
- Các thao tác nguy hiểm phải có xác nhận và phản hồi.

## 9.2. Design tokens

Xây dựng tokens tập trung cho:

- Màu thương hiệu, màu nền, viền, màu chữ.
- Màu trạng thái: success, warning, danger, info.
- Font family, font size, font weight và line-height.
- Khoảng cách, border radius, shadow.
- Breakpoints responsive.
- Chiều cao input, button, header, sidebar.
- Quy tắc focus, hover, disabled và error.

Không đặt màu và spacing tùy tiện cho từng màn hình. Các thành phần như button, input, select, badge, modal, table, pagination và notification nên dùng chung component.

## 9.3. Trạng thái UI bắt buộc

Mỗi màn hình có truy vấn dữ liệu hoặc thao tác cần thiết kế:

- Loading/skeleton.
- Empty state.
- Error state và retry.
- Success feedback.
- Validation error.
- Disabled state.
- Confirm dialog.
- Permission denied.
- Responsive overflow.
- Trạng thái không có kết quả tìm kiếm.

Prototype phải thể hiện các trạng thái này bằng dữ liệu giả lập. Không chỉ dựng màn hình đẹp ở trạng thái thành công.

# 10. API và tích hợp backend

Nếu triển khai backend thật, có thể tổ chức API theo nhóm sau:

| Nhóm API         | Ví dụ endpoint                                                             |
| ---------------- | -------------------------------------------------------------------------- |
| Authentication   | `POST /api/auth/register`, `/login`, `/otp/verify`                         |
| Catalog          | `GET /api/catalog/makes`, `/models`, `/generations`, `/trims`              |
| Search           | `GET /api/vehicles` với query parameters cho bộ lọc                        |
| Listings         | `POST /api/listings`, `GET /api/listings/{id}`, `PATCH /api/listings/{id}` |
| Listing Workflow | `POST /api/listings/{id}/submit`, `/approve`, `/reject`                    |
| Saved Vehicles   | `POST /api/saved-vehicles`, `DELETE /api/saved-vehicles/{id}`              |
| Seller           | `GET /api/sellers/{id}`, `/api/salons/{id}`                                |
| Notifications    | `GET /api/notifications`, `PATCH /api/notifications/{id}/read`             |
| Vehicle Alerts   | `POST /api/saved-searches`, `GET /api/saved-searches`                      |
| Deposits         | `POST /api/deposits`, `GET /api/deposits/{id}`                             |
| CMS              | `/api/admin/users`, `/api/admin/listings`, `/api/admin/catalog`            |
| Import / Export  | `/api/admin/catalog/import`, `/export`                                     |
| Analytics        | `/api/admin/analytics/overview`, `/listings`, `/transactions`              |

Đây là ví dụ định hướng, không phải hợp đồng API cuối cùng. Cần đặc tả request/response, schema lỗi, phân trang, validation, authorization và idempotency cho các endpoint nghiệp vụ quan trọng.

Với các tích hợp thanh toán, gửi OTP, email, SMS và lưu trữ media, nên dùng adapter hoặc interface riêng để có thể thay nhà cung cấp mà không phải viết lại toàn bộ nghiệp vụ.

# 11. Analytics và báo cáo

Dashboard quản trị có thể gồm:

- Tổng người dùng và người dùng mới.
- Tổng tin đăng, tin đang hoạt động, chờ duyệt, bị từ chối và hết hạn.
- Lượt xem xe và số lượt lưu xe.
- Tỷ lệ từ xem chi tiết sang liên hệ.
- Từ khóa tìm kiếm phổ biến.
- Tỷ lệ tìm kiếm không có kết quả.
- Hiệu quả các trang SEO.
- Số giao dịch đặt cọc theo trạng thái.
- Thời gian trung bình từ gửi tin đến duyệt.
- Tỷ lệ người bán hoàn thành quy trình đăng tin.

Mỗi chỉ số phải có định nghĩa rõ ràng. Ví dụ, “lượt xem xe” cần xác định cách loại trừ refresh, bot và lượt xem lặp; “tỷ lệ chuyển đổi” phải nêu rõ mẫu số, tử số và khoảng thời gian.

Không đưa dữ liệu minh họa vào dashboard như thể đó là số liệu thực. Prototype phải gắn nhãn dữ liệu mẫu.

# 12. Tổ chức mã nguồn prototype frontend

Với mục tiêu trước mắt là sinh giao diện HTML/CSS/JavaScript, có thể bắt đầu từ cấu trúc:

```
aoto-platform/
├── index.html
├── public/
│   ├── assets/
│   │   ├── images/
│   │   ├── icons/
│   │   └── fonts/
│   └── favicon.ico
├── src/
│   ├── styles/
│   │   ├── tokens.css
│   │   ├── global.css
│   │   ├── layout.css
│   │   ├── components.css
│   │   ├── website.css
│   │   └── admin.css
│   ├── js/
│   │   ├── app.js
│   │   ├── router.js
│   │   ├── mock-api.js
│   │   ├── mock-data.js
│   │   ├── validators.js
│   │   └── utils.js
│   ├── components/
│   │   ├── header.js
│   │   ├── footer.js
│   │   ├── vehicle-card.js
│   │   ├── filter-panel.js
│   │   ├── data-table.js
│   │   ├── modal.js
│   │   └── form-controls.js
│   └── pages/
│       ├── website/
│       ├── auth/
│       ├── seller/
│       ├── transactions/
│       ├── admin/
│       └── catalog/
├── docs/
│   ├── product-spec.md
│   ├── page-inventory.md
│   ├── catalog-data-model.md
│   ├── workflows.md
│   └── acceptance-criteria.md
└── README.md
```

Đây là cấu trúc gợi ý. Nếu sử dụng Bootstrap, Tailwind hoặc framework frontend, cần điều chỉnh cấu trúc theo cách build và quản lý component tương ứng.

## Nguyên tắc prototype

- Dùng dữ liệu mock tập trung, không lặp dữ liệu ở nhiều màn hình.
- Các thao tác CRUD có thể hoạt động trên mock store.
- Dùng `localStorage` chỉ cho dữ liệu demo không nhạy cảm.
- Không giả lập thanh toán thành công như một giao dịch thật.
- Không hard-code các option Catalog rải rác trong từng form.
- Có thể thay mock API bằng backend sau này.
- Có README hướng dẫn chạy, điều hướng và dữ liệu mẫu.
- Tách Public Website và Admin CMS về layout nhưng dùng chung design tokens và các component phù hợp.

# 13. Kế hoạch triển khai theo giai đoạn

Giai đoạn 1 — Foundation & Prototype

Thiết lập design system, routing, mock data, header/footer, responsive và layout CMS.

Kết quả: khung giao diện chạy được, điều hướng giữa các màn hình.

Giai đoạn 2 — Core Marketplace

Homepage, danh sách xe, bộ lọc, chi tiết xe, tài khoản, đăng tin và quản lý tin.

Kết quả: hoàn chỉnh hành trình cơ bản của người mua và người bán.

Giai đoạn 3 — Automotive Catalog

Hãng, model, generation, trim, thông số, thuộc tính mở rộng, địa giới, import/export.

Kết quả: chuẩn hóa dữ liệu xe và cấu hình bộ lọc.

Giai đoạn 4 — CMS & Governance

Kiểm duyệt, báo cáo vi phạm, RBAC, xác minh, audit log, media và nội dung SEO.

Kết quả: hệ thống có thể vận hành và kiểm soát chất lượng tin.

Giai đoạn 5 — Transactions & Analytics

Đặt cọc, tích hợp thanh toán, đối soát, thông báo, saved search và dashboard.

Kết quả: bổ sung quy trình giao dịch và theo dõi hiệu quả hoạt động.

Thứ tự triển khai có thể thay đổi theo ưu tiên kinh doanh. Tuy nhiên, Catalog, Listing và quy trình trạng thái cần được thống nhất trước khi phát triển sâu các bộ lọc và báo cáo phụ thuộc vào chúng.

# 14. Tiêu chí nghiệm thu

## Public Website

- Tất cả màn hình trong danh mục có thể truy cập qua điều hướng.
- Các trang chính hiển thị tốt trên desktop, tablet và mobile.
- Tìm kiếm và bộ lọc phối hợp đúng trên dữ liệu mock.
- Trang chi tiết hiển thị đầy đủ dữ liệu xe và thông tin người bán được phép công khai.
- Wizard đăng tin hỗ trợ validation, lưu nháp, xem trước và gửi duyệt giả lập.
- Quản lý tin, xe đã lưu, thông báo và hồ sơ có trạng thái rõ ràng.
- Không có nút chính chỉ mang tính trang trí mà không có hành vi.
- Có loading, empty, error và success states.

## Admin CMS

- Sidebar và điều hướng theo module.
- Bảng dữ liệu hỗ trợ tìm kiếm, lọc, sắp xếp và phân trang.
- Form thêm/sửa có validation và thông báo lỗi.
- Các thao tác duyệt/từ chối có lý do hoặc xác nhận phù hợp.
- Trạng thái và hành động được thể hiện thống nhất.
- Có trang quản lý Catalog và import/export mẫu.
- Có màn hình quản lý quyền, audit và cấu hình ở mức prototype.

## Automotive Catalog

- Quan hệ hãng → model → generation → trim được thể hiện đúng.
- Thuộc tính kỹ thuật được định nghĩa tập trung.
- Form thay đổi theo loại xe và bộ thuộc tính.
- Dữ liệu địa giới có quan hệ cha-con.
- Alias và slug hỗ trợ phát hiện trùng.
- Có báo cáo lỗi dữ liệu và lịch sử thay đổi ở mức phù hợp.
- Không xóa cứng dữ liệu đang được tin đăng hoặc phiên bản tham chiếu.

## Bảo mật và tính toàn vẹn

- Không công khai dữ liệu định danh nhạy cảm.
- Không chứa secret hoặc token thật trong frontend.
- Không tự xác nhận thanh toán thành công từ thao tác người dùng.
- Các trạng thái giao dịch và tin đăng nhất quán.
- Dữ liệu demo được đánh dấu rõ là dữ liệu minh họa.

# 15. MASTER PROMPT — Sinh giao diện Aoto.com.vn

Phần dưới đây có thể dùng làm prompt gốc cho AI tạo prototype. Nếu cần chất lượng tốt hơn, hãy cung cấp prompt này cùng từng nhóm màn hình theo giai đoạn, thay vì yêu cầu sinh toàn bộ website trong một lần.

# MASTER PROMPT — AOTO.COM.VN AUTOMOTIVE MARKETPLACE & ADMIN CMS

## 1. Vai trò

Bạn là Senior Product Designer, UX Architect và Frontend Engineer. Hãy thiết kế và xây dựng prototype giao diện cho Aoto.com.vn — nền tảng mua bán ô tô trực tuyến tại Việt Nam, bao gồm Public Website và Admin CMS.

Mục tiêu là tạo một prototype có cấu trúc rõ ràng, giao diện chuyên nghiệp, responsive, dữ liệu nhất quán và các tương tác chính có thể kiểm thử được.

## 2. Phạm vi sản phẩm

Xây dựng hai khu vực:

### A. Public Website

Bao gồm:

1. Homepage.
2. Danh sách xe.
3. Tìm kiếm và bộ lọc nâng cao.
4. Chi tiết xe.
5. Hồ sơ người bán.
6. Đăng ký.
7. Đăng nhập và OTP.
8. Wizard đăng tin.
9. Xem trước tin đăng.
10. Quản lý tin của tôi.
11. Xe đã lưu.
12. Hồ sơ cá nhân.
13. Thông báo.
14. Saved search / Vehicle alerts.
15. Đặt cọc.
16. Lịch sử giao dịch.
17. Hồ sơ showroom.
18. Help center và chính sách.
19. Error states.
20. Header, footer, menu và global components.

### B. Admin CMS

Bao gồm:

1. Dashboard.
2. Admin users, roles và permissions.
3. User management.
4. Xác minh cá nhân và showroom.
5. Listing management.
6. Moderation và reports.
7. Automotive Catalog.
8. Vehicle attribute management.
9. Deposit management.
10. Salon management.
11. Content management.
12. Media library.
13. Menu management.
14. SEO management.
15. Tag management.
16. Notification management.
17. Campaign management.
18. Analytics và reports.
19. System configuration.
20. Script/integration configuration an toàn.
21. Audit log.
22. Support management.
23. Legal content.
24. Search keywords và aliases.
25. Archive/retention.
26. Notification templates.
27. Security management.
28. Catalog import/export.

## 3. Automotive Catalog Management

Thiết kế phân hệ Catalog có khả năng quản lý các nhóm:

- Catalog dashboard.
- Vehicle types, segments và use purposes.
- Makes/brands.
- Countries/origins.
- Models.
- Generations.
- Trims/versions.
- Production years và variants.
- Model aliases và search aliases.
- Body types.
- Engine types.
- Fuel/energy types.
- Engine displacement.
- Power/torque.
- Transmissions.
- Drivetrains.
- Seat counts và door counts.
- Exterior/interior colors.
- Vehicle dimensions.
- Fuel consumption.
- EV battery specifications.
- Equipment/safety features.
- Emission standards.
- Inspection categories/statuses.
- Measurement units.
- Countries.
- Province/city and ward/commune.
- Display, salon, delivery and transaction areas.
- Vehicle, engine and transmission conditions.
- Accident/flood history.
- Airbag status.
- Document types.
- Vehicle verification statuses.
- Warranty policies.
- Extensible attribute definitions.
- Attribute sets per vehicle type.
- Search filter configuration.
- Trim/specification mapping.
- Catalog import/export.
- Data quality validation.
- Catalog audit history.
- Catalog SEO.
- Catalog status management.

Đây là danh sách nhóm chức năng. Hãy tái sử dụng component và form chung, không tạo các màn hình trùng lặp một cách máy móc.

## 4. Data model

Thiết kế dữ liệu theo quan hệ logic:

Vehicle Type → Make → Model → Generation → Trim → Vehicle Configuration.

Không ép tất cả thuộc tính kỹ thuật thành các node trong cây. Fuel, transmission, drivetrain, body type, colors, features và units nên là reference data hoặc quan hệ nhiều-nhiều khi phù hợp.

Phân biệt:

- Catalog: thông số kỹ thuật chuẩn của phiên bản.
- Listing: thông tin thực tế của chiếc xe đang được rao bán.
- Seller: người bán cá nhân hoặc showroom.
- Transaction: yêu cầu đặt cọc và trạng thái giao dịch.
- Content: nội dung CMS, media và SEO metadata.

Dùng mock data tập trung, có ID ổn định và liên kết nhất quán giữa các màn hình.

## 5. Design system

Tạo design system dùng chung cho Website và CMS:

- Design tokens cho màu, typography, spacing, radius, shadow và breakpoints.
- Buttons, inputs, selects, checkboxes, badges, modals, tables, pagination, tabs, cards và toast notifications.
- Loading, empty, error, success, disabled và permission-denied states.
- Responsive layouts.
- Accessible labels, keyboard focus và contrast hợp lý.

Public Website cần thể hiện tính chất marketplace ô tô hiện đại, hình ảnh xe nổi bật và thông tin dễ quét.

Admin CMS cần ưu tiên khả năng đọc dữ liệu, lọc, thao tác hàng loạt và quản trị hiệu quả.

## 6. Công nghệ prototype

Ưu tiên HTML, CSS và JavaScript thuần, có thể sử dụng Bootstrap hoặc Tailwind CSS. Có thể dùng thư viện icon và Chart.js nếu phù hợp.

Tổ chức code thành các module:

- Shared layout và components.
- Website pages.
- Authentication pages.
- Seller pages.
- Transaction pages.
- Admin pages.
- Catalog pages.
- Mock API.
- Mock data.
- Validation utilities.
- Design tokens.
- Global styles.

Không lặp code giữa các trang. Không hard-code cùng một danh mục ở nhiều file.

## 7. Tương tác bắt buộc

Các chức năng sau phải hoạt động trong prototype bằng dữ liệu mock:

- Điều hướng giữa các trang.
- Tìm kiếm, lọc, sắp xếp và phân trang.
- Lưu/bỏ lưu xe.
- Form đăng nhập/đăng ký/OTP ở chế độ demo.
- Wizard đăng tin và validation.
- Lưu nháp, xem trước và gửi tin.
- Hiển thị trạng thái tin đăng.
- Quản lý bản ghi Catalog: thêm, sửa, xem chi tiết, tìm kiếm và lọc.
- Chọn hãng để lọc model; chọn model để lọc generation; chọn generation để lọc trim.
- Form thuộc tính kỹ thuật thay đổi theo loại xe.
- Quản lý trạng thái bản ghi.
- Import/export mẫu và hiển thị lỗi validation.
- Quản lý menu, nội dung và SEO ở mức prototype.
- Hiển thị chart từ mock data.
- Modal xác nhận cho thao tác quan trọng.
- Toast hoặc feedback cho mọi hành động chính.

Không được chỉ làm giao diện tĩnh với các nút không có tác dụng.

## 8. Business states

Listing statuses:

Draft, Pending Review, Active, Reserved, Sold, Rejected, Violated, Expired, Hidden.

Deposit statuses:

Pending Payment, Verifying, Paid, Failed, Expired, Refund Pending, Refunded, Disputed.

Verification statuses:

Not Submitted, Pending, Verified, Rejected, Expired, Revoked.

Xây dựng chuyển trạng thái nhất quán. Các trạng thái thanh toán trong prototype chỉ là mô phỏng; không được tuyên bố đây là giao dịch thật.

## 9. Security constraints

- Không công khai giấy tờ định danh hoặc dữ liệu cá nhân nhạy cảm.
- Không nhúng secret/API key thật vào frontend.
- Không cho phép HTML/JavaScript tùy ý từ nội dung người dùng.
- Script/integration configuration phải dùng allowlist và quyền đặc biệt.
- Các thao tác quản trị quan trọng cần hiển thị xác nhận và lịch sử thay đổi.
- Không tự đánh dấu giao dịch Paid chỉ từ thao tác nhấn nút của người dùng.
- Phân biệt rõ dữ liệu mock và dữ liệu thực.

## 10. Output yêu cầu

Cung cấp:

1. Source code prototype có thể chạy.
2. README hướng dẫn khởi chạy.
3. Danh sách route/màn hình.
4. Mock data tập trung.
5. Design tokens và component dùng chung.
6. Các luồng nghiệp vụ chính có thể kiểm thử.
7. Catalog demo với quan hệ dữ liệu nhất quán.
8. Các trạng thái loading, empty, error và success.
9. Ghi chú rõ những chức năng cần backend thật.
10. Checklist nghiệm thu.

Không tuyên bố tích hợp thanh toán, OTP, xác minh giấy tờ hoặc API backend thật nếu chỉ đang mô phỏng bằng JavaScript.

## 11. Cách thực hiện

Triển khai theo từng giai đoạn:

Phase 1: Foundation, design tokens, layouts, routing và mock data.

Phase 2: Public Website — homepage, search, listing, detail, authentication và post listing.

Phase 3: Admin CMS — dashboard, users, listings, moderation và content.

Phase 4: Automotive Catalog — makes, models, generations, trims, configurations, attributes, geography và import/export.

Phase 5: Transactions, notifications, analytics và các chức năng nâng cao.

Sau mỗi giai đoạn, kiểm tra điều hướng, responsive, validation, tính nhất quán dữ liệu và các tương tác trước khi tiếp tục.

Ưu tiên chất lượng, khả năng mở rộng, tính nhất quán và khả năng bảo trì. Không bỏ qua màn hình chỉ vì danh sách dài; hãy tái sử dụng component và tổ chức code theo module để triển khai có kiểm soát.

# 16. Kết luận và khuyến nghị cuối cùng

Để dự án không bị dàn trải, tôi khuyến nghị chốt ba quyết định trước khi bắt đầu sinh code:

1. Xây dựng Catalog trước khi hoàn thiện tìm kiếm và đăng tin. Nếu dữ liệu hãng/model/phiên bản không chuẩn hóa, bộ lọc sẽ nhanh chóng phát sinh lỗi và dữ liệu trùng.
2. Phân biệt prototype và sản phẩm vận hành thật. Prototype có thể dùng HTML/CSS/JS và mock API; đăng nhập, thanh toán, phân quyền, lưu dữ liệu và xử lý webhook cần backend thực tế.
3. Phát triển theo các luồng nghiệp vụ xuyên suốt. Ưu tiên hành trình người mua tìm xe, người bán đăng xe, quản trị viên duyệt tin và quy trình đặt cọc. Những luồng này quan trọng hơn việc hoàn thiện hàng chục màn hình riêng lẻ nhưng không liên kết với nhau.

Thứ tự khởi đầu phù hợp nhất: Design System → Mock Data Model → Homepage/Search/Detail → Post Listing → Admin Listing Management → Automotive Catalog → Authentication/Authorization → Deposit & Analytics.

Bản đặc tả trên là baseline cho UI/UX và prototype. Trước khi triển khai production, cần bổ sung tài liệu API contract, ERD chi tiết, ma trận quyền, quy tắc chuyển trạng thái, chính sách dữ liệu cá nhân, quy trình thanh toán/hoàn cọc và tiêu chí kiểm thử nghiệp vụ.