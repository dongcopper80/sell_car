-- ============================================================
-- OtoChinhChu — v1 Data (camelCase khớp schema thực tế TypeORM)
-- Idempotent. Chạy SAU v1_schema.sql
-- ============================================================

INSERT INTO users (id, email, "fullName", role, status, "identityVerified", "passwordHash") VALUES
  ('11111111-1111-1111-1111-111111111111', 'admin@otochinhchu.vn', 'Quản trị viên',  'admin',    'active', TRUE,  '$2b$10$8UNBnv5KPYCQVLGC9BXTpe7mGv7vGZP8PTiVBCgpLnHCoZLx3cyfa'),
  ('22222222-2222-2222-2222-222222222222', 'salon@otochinhchu.vn', 'Minh Phát Auto', 'business', 'active', TRUE,  '$2b$10$0KqdTLwxlIbwZ1uGDeUXwu9wTvCTOlkjqXju8CCTTvkHV1CT8CaHS'),
  ('33333333-3333-3333-3333-333333333333', 'buyer@otochinhchu.vn', 'Nguyễn Văn A',   'buyer',    'active', FALSE, '$2b$10$YtuVBNwHhZ2HGILKyeVAveJE99Cx7BOAasMHxe.EQQOrWfCVHKVF6')
ON CONFLICT (id) DO NOTHING;

INSERT INTO business_accounts (id, code, "ownerId", "companyName", "businessLicenseNumber", "taxCode", "representativeName", email, phone, address, "bankName", "bankAccountNumber", "bankAccountHolder", "documentsVerified", "verifiedAt", "createdById", status)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'DN-000001',
   '22222222-2222-2222-2222-222222222222',
   'Công ty TNHH Minh Phát Auto', '0106789123', '0106789123', 'Trần Minh Phát',
   'contact@minhphatauto.vn', '0901234567',
   '12 Nguyễn Trãi, Cầu Giấy, Hà Nội',
   'Vietcombank', '0011002233445', 'CONG TY TNHH MINH PHAT AUTO',
   TRUE, NOW(), '11111111-1111-1111-1111-111111111111', 'active')
ON CONFLICT (id) DO NOTHING;

INSERT INTO business_documents ("businessAccountId", "docType", "fileUrl", verified, "verifiedById")
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'business_license',  '/uploads/demo/license.pdf', TRUE, '11111111-1111-1111-1111-111111111111'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'tax_code',          '/uploads/demo/tax.pdf',     TRUE, '11111111-1111-1111-1111-111111111111'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bank_confirmation', '/uploads/demo/bank.pdf',    TRUE, '11111111-1111-1111-1111-111111111111'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'representative_id', '/uploads/demo/rep.pdf',     TRUE, '11111111-1111-1111-1111-111111111111')
ON CONFLICT DO NOTHING;

-- ============================================================ Catalog
INSERT INTO catalog_items ("groupCode", code, name, "sortOrder") VALUES
  ('makes', 'toyota', 'Toyota', 1), ('makes', 'honda', 'Honda', 2), ('makes', 'mazda', 'Mazda', 3),
  ('makes', 'hyundai', 'Hyundai', 4), ('makes', 'kia', 'Kia', 5), ('makes', 'ford', 'Ford', 6),
  ('makes', 'mitsubishi', 'Mitsubishi', 7), ('makes', 'vinfast', 'VinFast', 8),
  ('makes', 'mercedes-benz', 'Mercedes-Benz', 9), ('makes', 'bmw', 'BMW', 10), ('makes', 'audi', 'Audi', 11),
  ('makes', 'lexus', 'Lexus', 12), ('makes', 'porsche', 'Porsche', 13), ('makes', 'land-rover', 'Land Rover', 14),
  ('makes', 'jeep', 'Jeep', 15), ('makes', 'subaru', 'Subaru', 16), ('makes', 'suzuki', 'Suzuki', 17),
  ('makes', 'isuzu', 'Isuzu', 18), ('makes', 'nissan', 'Nissan', 19), ('makes', 'mg', 'MG', 20),
  ('makes', 'peugeot', 'Peugeot', 21), ('makes', 'volkswagen', 'Volkswagen', 22), ('makes', 'volvo', 'Volvo', 23),
  ('makes', 'skoda', 'Skoda', 24), ('makes', 'mini', 'MINI', 25), ('makes', 'rolls-royce', 'Rolls-Royce', 26),
  ('makes', 'bentley', 'Bentley', 27), ('makes', 'tesla', 'Tesla', 28), ('makes', 'ferrari', 'Ferrari', 29),
  ('makes', 'lamborghini', 'Lamborghini', 30), ('makes', 'maserati', 'Maserati', 31),
  ('makes', 'haima', 'Haima', 32), ('makes', 'baic', 'BAIC', 33), ('makes', 'dongfeng', 'Dongfeng', 34),
  ('makes', 'jac', 'JAC', 35), ('makes', 'chery', 'Chery', 36), ('makes', 'geely', 'Geely', 37),
  ('makes', 'haval', 'Haval', 38), ('makes', 'khac', 'Ô tô khác', 39),
  ('fuels', 'petrol', 'Xăng', 1), ('fuels', 'diesel', 'Diesel', 2), ('fuels', 'electric', 'Điện', 3), ('fuels', 'hybrid', 'Hybrid', 4),
  ('transmissions', 'automatic', 'Tự động', 1), ('transmissions', 'manual', 'Số sàn', 2),
  ('colors', 'white', 'Trắng', 1), ('colors', 'black', 'Đen', 2), ('colors', 'silver', 'Bạc', 3),
  ('colors', 'gray', 'Xám', 4), ('colors', 'blue', 'Xanh dương', 5), ('colors', 'red', 'Đỏ', 6),
  ('colors', 'brown', 'Nâu', 7), ('colors', 'green', 'Xanh lá', 8), ('colors', 'orange', 'Cam', 9),
  ('colors', 'yellow', 'Vàng', 10), ('colors', 'beige', 'Vàng cát', 11), ('colors', 'purple', 'Tím', 12), ('colors', 'pink', 'Hồng', 13),
  ('seats', '2', '2 chỗ', 1), ('seats', '4', '4 chỗ', 2), ('seats', '5', '5 chỗ', 3), ('seats', '7', '7 chỗ', 4),
  ('seats', '8', '8 chỗ', 5), ('seats', '9', '9 chỗ', 6), ('seats', '11', '11 chỗ', 7), ('seats', '16', '16 chỗ', 8),
  ('seats', '18', '18 chỗ', 9), ('seats', '29', '29 chỗ', 10)
ON CONFLICT ("groupCode", code) DO NOTHING;

INSERT INTO catalog_items ("groupCode", code, name, "parentId", "sortOrder")
SELECT 'models', m.mc, m.mn, mk.id, ROW_NUMBER() OVER (ORDER BY mk.name, m.mn)::int
FROM (VALUES
  ('toyota', 'toyota-corolla-cross', 'Corolla Cross'), ('toyota', 'toyota-vios', 'Vios'),
  ('toyota', 'toyota-camry', 'Camry'), ('toyota', 'toyota-innova', 'Innova'),
  ('toyota', 'toyota-fortuner', 'Fortuner'), ('toyota', 'toyota-hilux', 'Hilux'),
  ('toyota', 'toyota-land-cruiser', 'Land Cruiser'), ('toyota', 'toyota-alfa', 'Alphard'),
  ('honda', 'honda-city', 'City'), ('honda', 'honda-civic', 'Civic'),
  ('honda', 'honda-crv', 'CR-V'), ('honda', 'honda-hrv', 'HR-V'),
  ('honda', 'honda-brv', 'BR-V'), ('honda', 'honda-accord', 'Accord'),
  ('mazda', 'mazda-cx3', 'CX-3'), ('mazda', 'mazda-cx5', 'CX-5'),
  ('mazda', 'mazda-cx8', 'CX-8'), ('mazda', 'mazda-cx30', 'CX-30'),
  ('mazda', 'mazda-mazda2', 'Mazda2'), ('mazda', 'mazda-mazda3', 'Mazda3'), ('mazda', 'mazda-mazda6', 'Mazda6'),
  ('mazda', 'mazda-bt50', 'BT-50'),
  ('hyundai', 'hyundai-accent', 'Accent'), ('hyundai', 'hyundai-elantra', 'Elantra'),
  ('hyundai', 'hyundai-tucson', 'Tucson'), ('hyundai', 'hyundai-santa-fe', 'Santa Fe'),
  ('hyundai', 'hyundai-creta', 'Creta'), ('hyundai', 'hyundai-staria', 'Staria'),
  ('kia', 'kia-rio', 'Rio'), ('kia', 'kia-cerato', 'Cerato'), ('kia', 'kia-seltos', 'Seltos'),
  ('kia', 'kia-sportage', 'Sportage'), ('kia', 'kia-sonet', 'Sonet'), ('kia', 'kia-sorento', 'Sorento'),
  ('kia', 'kia-carnival', 'Carnival'), ('kia', 'kia-morning', 'Morning'),
  ('ford', 'ford-ranger', 'Ranger'), ('ford', 'ford-everest', 'Everest'),
  ('ford', 'ford-territory', 'Territory'),
  ('mitsubishi', 'mitsubishi-triton', 'Triton'), ('mitsubishi', 'mitsubishi-pajero-sport', 'Pajero Sport'),
  ('mitsubishi', 'mitsubishi-outlander', 'Outlander'), ('mitsubishi', 'mitsubishi-xpander', 'Xpander'),
  ('mitsubishi', 'mitsubishi-xforce', 'Xforce'),
  ('vinfast', 'vinfast-vf3', 'VF 3'), ('vinfast', 'vinfast-vf5', 'VF 5'),
  ('vinfast', 'vinfast-vf6', 'VF 6'), ('vinfast', 'vinfast-vf7', 'VF 7'),
  ('vinfast', 'vinfast-vf8', 'VF 8'), ('vinfast', 'vinfast-vf9', 'VF 9'),
  ('vinfast', 'vinfast-president', 'President')
) AS m(mkc, mc, mn)
JOIN catalog_items mk ON mk."groupCode" = 'makes' AND mk.code = m.mkc
ON CONFLICT ("groupCode", code) DO NOTHING;

INSERT INTO catalog_items ("groupCode", code, name, "sortOrder") VALUES
  ('provinces', '01', 'Hà Nội', 1), ('provinces', '79', 'TP. Hồ Chí Minh', 2), ('provinces', '40', 'Đà Nẵng', 3),
  ('provinces', '92', 'Cần Thơ', 4), ('provinces', '31', 'Bình Dương', 5), ('provinces', '33', 'Đồng Nai', 6),
  ('provinces', '51', 'Khánh Hòa', 7), ('provinces', '62', 'Lâm Đồng', 8), ('provinces', '30', 'Thanh Hóa', 9),
  ('provinces', '32', 'Nghệ An', 10), ('provinces', '42', 'Quảng Nam', 11), ('provinces', '45', 'Bình Định', 12),
  ('provinces', '44', 'Quảng Ngãi', 13), ('provinces', '47', 'Phú Yên', 14), ('provinces', '52', 'Bình Thuận', 15),
  ('provinces', '56', 'Gia Lai', 16), ('provinces', '58', 'Đắk Lắk', 17), ('provinces', '60', 'Đắk Nông', 18),
  ('provinces', '64', 'Bình Phước', 19), ('provinces', '66', 'Tây Ninh', 20), ('provinces', '68', 'Long An', 21),
  ('provinces', '70', 'Tiền Giang', 22), ('provinces', '72', 'Bến Tre', 23), ('provinces', '74', 'Trà Vinh', 24),
  ('provinces', '75', 'Vĩnh Long', 25), ('provinces', '77', 'Đồng Tháp', 26), ('provinces', '78', 'An Giang', 27),
  ('provinces', '80', 'Kiên Giang', 28), ('provinces', '82', 'Hậu Giang', 29), ('provinces', '84', 'Sóc Trăng', 30),
  ('provinces', '86', 'Bạc Liêu', 31), ('provinces', '87', 'Cà Mau', 32), ('provinces', '89', 'Bắc Ninh', 33),
  ('provinces', '95', 'Hà Nam', 34), ('provinces', '96', 'Nam Định', 35), ('provinces', '94', 'Thái Bình', 36),
  ('provinces', '98', 'Ninh Bình', 37), ('provinces', '97', 'Hòa Bình', 38), ('provinces', '99', 'Sơn La', 39),
  ('provinces', '02', 'Tuyên Quang', 40), ('provinces', '06', 'Hưng Yên', 41), ('provinces', '08', 'Hải Dương', 42),
  ('provinces', '11', 'Thái Nguyên', 43), ('provinces', '14', 'Lạng Sơn', 44), ('provinces', '15', 'Cao Bằng', 45),
  ('provinces', '17', 'Bắc Kạn', 46), ('provinces', '18', 'Bắc Giang', 47), ('provinces', '19', 'Phú Thọ', 48),
  ('provinces', '20', 'Vĩnh Phúc', 49), ('provinces', '22', 'Yên Bái', 50), ('provinces', '24', 'Lào Cai', 51),
  ('provinces', '26', 'Điện Biên', 52), ('provinces', '28', 'Lai Châu', 53), ('provinces', '36', 'Hà Tĩnh', 54),
  ('provinces', '37', 'Quảng Bình', 55), ('provinces', '38', 'Quảng Trị', 56), ('provinces', '46', 'Thừa Thiên Huế', 57),
  ('provinces', '49', 'Ninh Thuận', 58), ('provinces', '54', 'Kon Tum', 59)
ON CONFLICT ("groupCode", code) DO NOTHING;

-- ============================================================ Vehicles mẫu
INSERT INTO vehicles (id, "sellerId", "sellerType", "businessAccountId", title, "makeId", "modelId", year, "odometerKm", transmission, "fuelType", "priceVnd", location, "provinceCode", description, photos, status, verified, "moderatedById", "viewCount")
SELECT 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
       '22222222-2222-2222-2222-222222222222', 'business', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
       'Toyota Corolla Cross 1.8V 2023', mk.id, md.id,
       2023, 18000, 'automatic', 'petrol', 820000000, 'Quận Cầu Giấy, Hà Nội', '01',
       'Xe chính chủ, bảo dưỡng dealer, full option.',
       '["https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=80","https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80"]'::jsonb,
       'published', TRUE, '11111111-1111-1111-1111-111111111111', 320
FROM catalog_items mk, catalog_items md
WHERE mk."groupCode"='makes' AND mk.code='toyota' AND md."groupCode"='models' AND md.code='toyota-corolla-cross'
ON CONFLICT (id) DO NOTHING;

INSERT INTO vehicles (id, "sellerId", "sellerType", "businessAccountId", title, "makeId", "modelId", year, "odometerKm", transmission, "fuelType", "priceVnd", location, "provinceCode", description, photos, status)
SELECT 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
       '22222222-2222-2222-2222-222222222222', 'business', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
       'Mazda CX-5 2.0 Premium 2022', mk.id, md.id,
       2022, 26500, 'automatic', 'petrol', 765000000, 'Thủ Đức, TP. HCM', '79',
       'Mới 95%, còn bảo hành hãng.',
       '["https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=81","https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&q=80"]'::jsonb,
       'pending_review'
FROM catalog_items mk, catalog_items md
WHERE mk."groupCode"='makes' AND mk.code='mazda' AND md."groupCode"='models' AND md.code='mazda-cx5'
ON CONFLICT (id) DO NOTHING;

INSERT INTO vehicles (id, "sellerId", "sellerType", title, "makeId", "modelId", year, "odometerKm", transmission, "fuelType", "priceVnd", location, "provinceCode", description, photos, status, "viewCount")
SELECT 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3',
       '33333333-3333-3333-3333-333333333333', 'personal',
       'Honda CR-V L 1.5 Turbo 2021', mk.id, md.id,
       2021, 32000, 'automatic', 'petrol', 898000000, 'Hải Châu, Đà Nẵng', '40',
       'Đi ít, giữ gìn như mới.',
       '["https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=800&q=80","https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800&q=80"]'::jsonb,
       'published', 87
FROM catalog_items mk, catalog_items md
WHERE mk."groupCode"='makes' AND mk.code='honda' AND md."groupCode"='models' AND md.code='honda-crv'
ON CONFLICT (id) DO NOTHING;

INSERT INTO deposits (id, "referenceCode", "buyerId", "vehicleId", "amountVnd", status)
VALUES ('dddddddd-dddd-dddd-dddd-dddddddddd01', 'DEP-2026-000021',
        '33333333-3333-3333-3333-333333333333', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
        20000000, 'pending_payment')
ON CONFLICT ("referenceCode") DO NOTHING;

INSERT INTO notifications ("userId", title, body) VALUES
  ('33333333-3333-3333-3333-333333333333', 'Chào mừng đến Aoto', 'Bạn có thể lưu xe yêu thích và đặt cọc an toàn.'),
  ('22222222-2222-2222-2222-222222222222', 'Tin mới đang chờ duyệt', 'Mazda CX-5 đang chờ kiểm duyệt.')
ON CONFLICT DO NOTHING;
