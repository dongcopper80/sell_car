import 'reflect-metadata';
import 'dotenv/config';
import { DataSource } from 'typeorm';
import { join } from 'path';
import { User } from '../entities/user.entity';
import { BusinessAccount } from '../entities/business-account.entity';
import { BusinessDocument } from '../entities/business-document.entity';
import { Vehicle } from '../entities/vehicle.entity';
import { Deposit } from '../entities/deposit.entity';
import { CatalogItem } from '../entities/catalog-item.entity';
import { AuditLog } from '../entities/audit-log.entity';
import { Notification } from '../entities/notification.entity';

/**
 * DataSource dành cho TypeORM CLI (migration generate/run/revert).
 * Cấu hình đọc từ .env — giống runtime nhưng KHÔNG tự synchronize.
 */
export default new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  username: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASS || 'postgres',
  database: process.env.DB_NAME || 'otochinhchu',
  entities: [User, BusinessAccount, BusinessDocument, Vehicle, Deposit, CatalogItem, AuditLog, Notification],
  migrations: [join(__dirname, 'migrations/*{.ts,.js}')],
  synchronize: false,
  logging: false,
});
