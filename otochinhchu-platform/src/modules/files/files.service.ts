import { BadRequestException, Injectable } from '@nestjs/common';
import { diskStorage } from 'multer';
import { extname, join } from 'path';
import { existsSync, mkdirSync } from 'fs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class FilesService {
  constructor(private readonly config: ConfigService) { }

  static multerOptions() {
    const uploadDir = join(process.cwd(), process.env.UPLOAD_DIR || 'public/uploads');
    if (!existsSync(uploadDir)) mkdirSync(uploadDir, { recursive: true });
    return {
      storage: diskStorage({
        destination: uploadDir,
        filename: (_req, file, cb) => {
          const unique = `${Date.now()}-${Math.round(Math.random() * 1e6)}`;
          cb(null, `${unique}${extname(file.originalname).toLowerCase()}`);
        },
      }),
      limits: { fileSize: 5 * 1024 * 1024 },
      fileFilter: (_req, file, cb) => {
        if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.mimetype)) {
          return cb(new BadRequestException('Chỉ chấp nhận ảnh JPG/PNG/WebP'), false);
        }
        cb(null, true);
      },
    };
  }

  publicUrl(filename: string) {
    return `/uploads/${filename}`;
  }
}
