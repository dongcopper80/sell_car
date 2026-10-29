import 'reflect-metadata';
import 'dotenv/config';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import {
  AccountStatus, BusinessAccount, BusinessDocType, BusinessDocument, CatalogItem,
  Deposit, DepositStatus, Notification, User, UserRole, Vehicle, VehicleStatus,
} from '../entities';
import { join } from 'path';

const ds = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  username: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASS || 'postgres',
  database: process.env.DB_NAME || 'otochinhchu',
  entities: [join(__dirname, '../entities/*.entity{.ts,.js}')],
  synchronize: true,
  logging: false,
});

async function main() {
  await ds.initialize();
  const qr = ds.createQueryRunner();
  await qr.query('TRUNCATE TABLE notifications, audit_logs, deposits, vehicles, business_documents, business_accounts, catalog_items, users RESTART IDENTITY CASCADE');

  // ---------- users ----------
  const adminRepo = ds.getRepository(User);
  const admin = await adminRepo.save({
    email: 'admin@otochinhchu.vn',
    fullName: 'Quản trị viên',
    role: UserRole.ADMIN,
    passwordHash: await bcrypt.hash('admin123', 10),
    identityVerified: true,
  });
  const sellerUser = await adminRepo.save({
    email: 'salon@otochinhchu.vn',
    fullName: 'Minh Phát Auto',
    role: UserRole.BUSINESS,
    passwordHash: await bcrypt.hash('salon123', 10),
    identityVerified: true,
  });
  const buyer = await adminRepo.save({
    email: 'buyer@otochinhchu.vn',
    fullName: 'Nguyễn Văn A',
    role: UserRole.BUYER,
    passwordHash: await bcrypt.hash('buyer123', 10),
  });

  // ---------- business account ----------
  const baRepo = ds.getRepository(BusinessAccount);
  const ba = await baRepo.save({
    code: 'DN-000001',
    owner: sellerUser,
    ownerId: sellerUser.id,
    companyName: 'Công ty TNHH Minh Phát Auto',
    businessLicenseNumber: '0106789123',
    taxCode: '0106789123',
    representativeName: 'Trần Minh Phát',
    email: 'contact@minhphatauto.vn',
    phone: '0901234567',
    address: '12 Nguyễn Trãi, Cầu Giấy, Hà Nội',
    bankName: 'Vietcombank',
    bankAccountNumber: '0011002233445',
    bankAccountHolder: 'CONG TY TNHH MINH PHAT AUTO',
    documentsVerified: true,
    verifiedAt: new Date(),
    createdById: admin.id,
    status: AccountStatus.ACTIVE,
  });
  const docRepo = ds.getRepository(BusinessDocument);
  await docRepo.save([
    { businessAccountId: ba.id, docType: BusinessDocType.BUSINESS_LICENSE, fileUrl: '/uploads/demo/license.pdf', verified: true, verifiedById: admin.id },
    { businessAccountId: ba.id, docType: BusinessDocType.TAX_CODE, fileUrl: '/uploads/demo/tax.pdf', verified: true, verifiedById: admin.id },
    { businessAccountId: ba.id, docType: BusinessDocType.BANK_CONFIRMATION, fileUrl: '/uploads/demo/bank.pdf', verified: true, verifiedById: admin.id },
    { businessAccountId: ba.id, docType: BusinessDocType.REPRESENTATIVE_ID, fileUrl: '/uploads/demo/rep.pdf', verified: true, verifiedById: admin.id },
  ]);

  // ---------- catalog ----------
  const catalogRepo = ds.getRepository(CatalogItem);
  // ---------- catalog: dữ liệu đầy đủ ----------
  const makeDefs: Array<[string, string, string[]]> = [
    ['toyota', 'Toyota', ['corolla-cross', 'vios', 'yaris-cross', 'camry', 'innova', 'fortuner', 'hilux', 'hilux-surf', 'land-cruiser', 'alfa', 'avanza', 'rush', 'veloz', 'hiace', 'coaster']],
    ['honda', 'Honda', ['city', 'civic', 'crv', 'hrv', 'brv', 'accord', 'civic-type-r', 'odyssey', 'jazz']],
    ['mazda', 'Mazda', ['cx3', 'cx5', 'cx8', 'cx30', 'cx60', 'mazda2', 'mazda3', 'mazda6', 'bt50']],
    ['hyundai', 'Hyundai', ['accent', 'elantra', 'sonata', 'i10', 'i20', 'tucson', 'santa-fe', 'creta', 'staria', 'stargazer', 'porter', 'hd120']],
    ['kia', 'Kia', ['rio', 'cerato', 'k3', 'k5', 'seltos', 'sportage', 'sonet', 'sorento', 'carnival', 'picanto', 'morning', 'rontis']],
    ['ford', 'Ford', ['ranger', 'ranger-raptor', 'everest', 'territory', 'ecosport', 'focus', 'explorer', 'transit']],
    ['mitsubishi', 'Mitsubishi', ['triton', 'pajero-sport', 'outlander', 'xpander', 'attrage', 'mirage', 'xforce', 'eclipse-cross']],
    ['vinfast', 'VinFast', ['vf3', 'vf5', 'vf6', 'vf7', 'vf8', 'vf9', 'president', 'lux-a2', 'lux-sa', 'fadil', 'lux-gre', 'eco5']],
    ['mercedes-benz', 'Mercedes-Benz', ['a-class', 'c-class', 'e-class', 's-class', 'glc', 'gle', 'gls', 'g-class', 'eqe', 'eqs', 'v-class', 'maybach']],
    ['bmw', 'BMW', ['series-3', 'series-5', 'series-7', 'x1', 'x3', 'x5', 'x7', 'i4', 'ix', 'm3', 'm5']],
    ['audi', 'Audi', ['a3', 'a4', 'a6', 'a8', 'q3', 'q5', 'q7', 'q8', 'e-tron', 'rs6']],
    ['lexus', 'Lexus', ['ux', 'nx', 'rx', 'lx', 'es', 'ls', 'lm', 'gx']],
    ['porsche', 'Porsche', ['macan', 'cayenne', 'panamera', 'taycan', '911']],
    ['lexusvna', 'Land Rover', ['range-rover', 'range-rover-sport', 'discovery', 'defender', 'evoque', 'velar']],
    ['jeep', 'Jeep', ['wrangler', 'grand-cherokee', 'renegade']],
    ['subaru', 'Subaru', ['forester', 'outback', 'xv', 'wrx']],
    ['suzuki', 'Suzuki', ['swift', 'ertiga', 'xl7', 'vitara', 'carry', 'pro']],
    ['isuzu', 'Isuzu', ['dmax', 'mu-x', 'hi-lander']],
    ['nissan', 'Nissan', ['x-trail', 'kicks', 'terra', 'navara', 'almera', 'sunny', 'teana', 'patrol', 'urvan']],
    ['mg', 'MG', ['zs', 'hs', 'rx5', 'rx8', 'mg5', 'g10', 'maxus', 'wins']],
    ['peugeot', 'Peugeot', ['2008', '3008', '5008', 'landtrek', 'expert', 'traveller']],
    ['volkswagen', 'Volkswagen', ['polo', 'vento', 'golf', 'tiguan', 'touareg', 'caddy', 'multivan', 'passat']],
    ['volvo', 'Volvo', ['xc40', 'xc60', 'xc90', 's60', 's90', 'c40']],
    ['skoda', 'Skoda', ['kodiaq', 'karoq', 'superb', 'octavia']],
    ['mini', 'MINI', ['cooper', 'countryman', 'clubman', 'paceman']],
    ['rolls-royce', 'Rolls-Royce', ['phantom', 'ghost', 'cullinan', 'wraith']],
    ['bentley', 'Bentley', ['continental-gt', 'bentayga', 'flying-spur']],
    ['tesla', 'Tesla', ['model-3', 'model-y', 'model-s', 'model-x']],
    ['ferrari', 'Ferrari', ['sf90', 'f8', '488', '296-gtb']],
    ['lamborghini', 'Lamborghini', ['urus', 'huracan', 'aventador']],
    ['maserati', 'Maserati', ['ghibli', 'levante', 'quattroporte', 'grecale']],
    ['haima', 'Haima', ['7x', 's5', '8s']],
    ['baic', 'BAIC', ['bj40', 'bj80', 'x55', 'd20']],
    ['dfa', 'Dongfeng', ['t5', 'mhabit', 'v21', 'rich6']],
    ['jac', 'JAC', ['x35', 't6', 't8', 's3']],
    ['chery', 'Chery', ['tiggo-8', 'tiggo-7', 'tiggo-3x']],
    ['geely', 'Geely', ['azkarra', 'coolray', 'monjaro']],
    ['haval', 'Haval', ['h6', 'jolion', 'dargo']],
    ['chy-sochu', 'Oto Khác', ['khac']],
  ];
  const makes: Record<string, string> = {};
  for (const [code, name] of makeDefs) {
    const row = await catalogRepo.save({ groupCode: 'makes', code, name, sortOrder: makeDefs.findIndex((d) => d[0] === code) + 1 });
    makes[code] = row.id;
  }
  let modelSeq = 1;
  for (const [makeCode, , models] of makeDefs) {
    for (const modelCode of models) {
      const label = modelCode.replaceAll('-', ' ').replace(/\b\w/g, (c) => c.toUpperCase());
      await catalogRepo.save({ groupCode: 'models', code: `${makeCode}-${modelCode}`, name: label, parentId: makes[makeCode], sortOrder: modelSeq++ });
    }
  }

  // Nhóm danh mục bổ sung: tỉnh/thành (63 đơn vị), nhiên liệu, hộp số, màu, số chỗ
  const provinces = [
    ['01', 'Hà Nội'], ['02', 'Tuyên Quang'], ['04', 'Hòa Bình'], ['06', 'Hưng Yên'], ['08', 'Hải Dương'],
    ['10', 'Hà Nam'], ['11', 'Thái Bình'], ['12', 'Nam Định'], ['14', 'Thái Nguyên'], ['15', 'Yên Bái'],
    ['17', 'Bắc Kạn'], ['18', 'Lạng Sơn'], ['19', 'Cao Bằng'], ['20', 'Lào Cai'], ['22', 'Điện Biên'],
    ['24', 'Lai Châu'], ['25', 'Sơn La'], ['26', 'Lạng Sơn'], ['27', 'Bắc Giang'], ['28', 'Ninh Bình'],
    ['30', 'Thanh Hóa'], ['32', 'Nghệ An'], ['34', 'Hà Tĩnh'], ['36', 'Quảng Bình'], ['38', 'Quảng Trị'],
    ['40', 'Đà Nẵng'], ['42', 'Quảng Nam'], ['44', 'Quảng Ngãi'], ['45', 'Bình Định'], ['47', 'Phú Yên'],
    ['49', 'Khánh Hòa'], ['51', 'Ninh Thuận'], ['52', 'Bình Thuận'], ['54', 'Kon Tum'], ['56', 'Gia Lai'],
    ['58', 'Đắk Lắk'], ['60', 'Đắk Nông'], ['62', 'Lâm Đồng'], ['64', 'Bình Phước'], ['66', 'Tây Ninh'],
    ['68', 'Bình Dương'], ['70', 'Bình Phước'], ['72', 'Long An'], ['74', 'Tiền Giang'], ['75', 'Bến Tre'],
    ['77', 'Trà Vinh'], ['79', 'TP. Hồ Chí Minh'], ['80', 'Vĩnh Long'], ['82', 'Đồng Tháp'], ['84', 'An Giang'],
    ['86', 'Kiên Giang'], ['87', 'Hậu Giang'], ['89', 'Cà Mau'], ['91', 'Bạc Liêu'], ['92', 'Cần Thơ'],
    ['93', 'Sóc Trăng'], ['94', 'Bạc Liêu'], ['95', 'Bắc Ninh'], ['96', 'Bà Rịa - Vũng Tàu'], ['97', 'Quảng Ninh'],
    ['98', 'Hải Phòng'], ['99', 'Vĩnh Phúc'],
  ] as const;
  const provinceSet = new Set<string>();
  let pSeq = 1;
  for (const [code, name] of provinces) {
    if (provinceSet.has(code)) continue; // tránh trùng code khi gộp 63 tỉnh
    provinceSet.add(code);
    await catalogRepo.save({ groupCode: 'provinces', code, name, sortOrder: pSeq++ });
  }
  await catalogRepo.save([
    { groupCode: 'fuels', code: 'petrol', name: 'Xăng', sortOrder: 1 },
    { groupCode: 'fuels', code: 'diesel', name: 'Diesel', sortOrder: 2 },
    { groupCode: 'fuels', code: 'electric', name: 'Điện', sortOrder: 3 },
    { groupCode: 'fuels', code: 'hybrid', name: 'Hybrid', sortOrder: 4 },
    { groupCode: 'transmissions', code: 'automatic', name: 'Tự động', sortOrder: 1 },
    { groupCode: 'transmissions', code: 'manual', name: 'Số sàn', sortOrder: 2 },
    { groupCode: 'colors', code: 'white', name: 'Trắng', sortOrder: 1 },
    { groupCode: 'colors', code: 'black', name: 'Đen', sortOrder: 2 },
    { groupCode: 'colors', code: 'silver', name: 'Bạc', sortOrder: 3 },
    { groupCode: 'colors', code: 'gray', name: 'Xám', sortOrder: 4 },
    { groupCode: 'colors', code: 'blue', name: 'Xanh dương', sortOrder: 5 },
    { groupCode: 'colors', code: 'red', name: 'Đỏ', sortOrder: 6 },
    { groupCode: 'colors', code: 'brown', name: 'Nâu', sortOrder: 7 },
    { groupCode: 'colors', code: 'green', name: 'Xanh lá', sortOrder: 8 },
    { groupCode: 'colors', code: 'orange', name: 'Cam', sortOrder: 9 },
    { groupCode: 'colors', code: 'yellow', name: 'Vàng', sortOrder: 10 },
    { groupCode: 'colors', code: 'beige', name: 'Vàng cát', sortOrder: 11 },
    { groupCode: 'colors', code: 'purple', name: 'Tím', sortOrder: 12 },
    { groupCode: 'colors', code: 'pink', name: 'Hồng', sortOrder: 13 },
    { groupCode: 'seats', code: '2', name: '2 chỗ', sortOrder: 1 },
    { groupCode: 'seats', code: '4', name: '4 chỗ', sortOrder: 2 },
    { groupCode: 'seats', code: '5', name: '5 chỗ', sortOrder: 3 },
    { groupCode: 'seats', code: '7', name: '7 chỗ', sortOrder: 4 },
    { groupCode: 'seats', code: '8', name: '8 chỗ', sortOrder: 5 },
    { groupCode: 'seats', code: '9', name: '9 chỗ', sortOrder: 6 },
    { groupCode: 'seats', code: '11', name: '11 chỗ', sortOrder: 7 },
    { groupCode: 'seats', code: '16', name: '16 chỗ', sortOrder: 8 },
    { groupCode: 'seats', code: '18', name: '18 chỗ', sortOrder: 9 },
    { groupCode: 'seats', code: '29', name: '29 chỗ', sortOrder: 10 },
  ]);

  // ---------- vehicles ----------
  const vehicleRepo = ds.getRepository(Vehicle);
  const allVehicles = [
    {
      seller: sellerUser, sellerId: sellerUser.id, sellerType: 'business' as const, businessAccountId: ba.id,
      title: 'Toyota Corolla Cross 1.8V 2023', makeId: makes['toyota'], modelId: (await catalogRepo.findOne({ where: { groupCode: 'models', code: 'toyota-corolla-cross' } }))!.id,
      year: 2023, odometerKm: 18000, transmission: 'automatic', fuelType: 'petrol',
      priceVnd: 820000000, location: 'Cầu Giấy, Hà Nội', provinceCode: '01',
      description: 'Xe chính chủ, bảo dưỡng dealer, full option.',
      photos: ['https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=80', 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80'],
      status: VehicleStatus.PUBLISHED, verified: true, moderatedById: admin.id, viewCount: 320,
    },
    {
      seller: sellerUser, sellerId: sellerUser.id, sellerType: 'business' as const, businessAccountId: ba.id,
      title: 'Mazda CX-5 2.0 Premium 2022', makeId: makes['mazda'], modelId: (await catalogRepo.findOne({ where: { groupCode: 'models', code: 'mazda-cx5' } }))!.id,
      year: 2022, odometerKm: 26500, transmission: 'automatic', fuelType: 'petrol',
      priceVnd: 765000000, location: 'Thủ Đức, TP. HCM', provinceCode: '79',
      description: 'Mới 95%, còn bảo hành hãng.',
      photos: ['https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=81', 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&q=80'],
      status: VehicleStatus.PENDING_REVIEW,
    },
    {
      seller: buyer, sellerId: buyer.id, sellerType: 'personal' as const,
      title: 'Honda CR-V L 1.5 Turbo 2021', makeId: makes['honda'], modelId: (await catalogRepo.findOne({ where: { groupCode: 'models', code: 'honda-crv' } }))!.id,
      year: 2021, odometerKm: 32000, transmission: 'automatic', fuelType: 'petrol',
      priceVnd: 898000000, location: 'Hải Châu, Đà Nẵng', provinceCode: '48',
      description: 'Đi ít, giữ gìn như mới.',
      photos: ['https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=800&q=80', 'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800&q=80'],
      status: VehicleStatus.PUBLISHED, viewCount: 87,
    },
  ];
  await vehicleRepo.save(allVehicles as any);

  // ---------- deposit ----------
  await ds.getRepository(Deposit).save({
    referenceCode: 'DEP-2026-000021',
    buyer: buyer, buyerId: buyer.id,
    vehicleId: (await vehicleRepo.findOne({ where: { title: 'Toyota Corolla Cross 1.8V 2023' } }))!.id,
    amountVnd: 20000000,
    status: DepositStatus.PENDING_PAYMENT,
  });

  // ---------- notifications ----------
  const notiRepo = ds.getRepository(Notification);
  await notiRepo.save([
    { userId: buyer.id, title: 'Chào mừng đến Aoto', body: 'Bạn có thể lưu xe yêu thích và đặt cọc an toàn.' },
    { userId: sellerUser.id, title: 'Tin mới đang chờ duyệt', body: 'Mazda CX-5 đang chờ kiểm duyệt.' },
  ]);

  // ---------- audit ----------
  await ds.query('DELETE FROM audit_logs');
  await qr.release();
  console.log('✅ Seed done. admin@otochinhchu.vn / admin123 · salon@otochinhchu.vn / salon123 · buyer@otochinhchu.vn / buyer123');
  await ds.destroy();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
