import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { join } from 'path';
import { NestExpressApplication } from '@nestjs/platform-express';
import { existsSync, mkdirSync } from 'fs';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { cors: true });

  app.setGlobalPrefix('api/v1');
  app.use(helmet({ crossOriginResourcePolicy: { policy: 'cross-origin' } }));
  app.enableCors({ origin: true, credentials: true });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );
  app.useGlobalInterceptors(new TransformInterceptor());

  const config = new DocumentBuilder()
    .setTitle('OtoChinhChu API')
    .setDescription([
      'API dùng chung cho **Website**, **CMS** và **App mobile** (REST, JSON).',
      '',
      '## Xác thực',
      '- Cá nhân: bắt buộc **VNeID** (OAuth) — `GET /auth/vneid/callback?code=...`',
      '- Admin/CMS: `POST /auth/login` (email + mật khẩu) → Bearer token',
      '- Gắn header: `Authorization: Bearer <accessToken>`',
      '',
      '## Response chuẩn',
      'Mọi endpoint trả `{ code, data, timestamp }`. Lỗi trả `{ code, message, details? }`.',
      '',
      '## Luồng nghiệp vụ chính',
      '- Tin đăng: `draft → pending_review → published/rejected → sold/expired` (chặn nhảy cóc)',
      '- Đặt cọc: `pending_payment → verifying → paid` (chỉ admin xác nhận)',
      '- Doanh nghiệp: chỉ CMS tạo sau khi đối chiếu 4 loại giấy tờ',
    ].join('\n'))
    .setVersion('1.0')
    .setContact('OtoChinhChu', 'https://otochinhchu.vn', 'support@otochinhchu.vn')
    .setLicense('Private', 'https://otochinhchu.vn/license')
    .addServer('http://localhost:3000', 'Local dev')
    .addBearerAuth(
      { type: 'http', scheme: 'bearer', bearerFormat: 'JWT', description: 'Nhập accessToken từ /auth/login hoặc /auth/vneid/callback' },
      'bearer',
    )
    .addTag('auth', 'Đăng nhập, VNeID, phiên người dùng')
    .addTag('users', 'Quản lý người dùng (admin)')
    .addTag('vehicles', 'Tin đăng xe: tìm kiếm, đăng, duyệt')
    .addTag('cms/business-accounts', 'CMS: tài khoản doanh nghiệp')
    .addTag('cms/content', 'CMS: trang nội dung & pháp lý')
    .addTag('cms/audit', 'CMS: nhật ký hệ thống')
    .addTag('deposits', 'Đặt cọc & đối soát')
    .addTag('catalog', 'Danh mục dùng chung (hãng, dòng xe, tỉnh...)')
    .addTag('notifications', 'Thông báo in-app')
    .addTag('files', 'Tải lên ảnh')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document, {
    swaggerOptions: { persistAuthorization: true, tagsSorter: 'alpha', operationsSorter: 'alpha' },
    customSiteTitle: 'OtoChinhChu API Docs',
  });

  // Xuất OpenAPI JSON ra file để làm tài liệu tĩnh (chạy kèm build)
  const { writeFileSync } = await import('fs');
  writeFileSync(join(process.cwd(), 'public', 'openapi.json'), JSON.stringify(document, null, 2), 'utf8');
  console.log('OpenAPI JSON: public/openapi.json');

  const uploadDir = join(process.cwd(), process.env.UPLOAD_DIR || 'public/uploads');
  if (!existsSync(uploadDir)) mkdirSync(uploadDir, { recursive: true });
  app.useStaticAssets(join(process.cwd(), 'public'));

  await app.listen(process.env.PORT || 3000);
  console.log(`API: http://localhost:${process.env.PORT || 3000}/api/docs`);
}
bootstrap();
