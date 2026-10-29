import type { ConfigService } from '@nestjs/config';
import { join } from 'path';
import { DataSourceOptions } from 'typeorm';

export default (configService: ConfigService): DataSourceOptions => ({
  type: 'postgres',
  host: configService.get('DB_HOST', 'localhost'),
  port: configService.get<number>('DB_PORT', 5432),
  username: configService.get('DB_USER', 'postgres'),
  password: configService.get('DB_PASS', 'postgres'),
  database: configService.get('DB_NAME', 'otochinhchu'),
  entities: [join(__dirname, '../database/entities/*.entity{.ts,.js}')],
  synchronize: configService.get('DB_SYNC', 'true') === 'true',
  logging: process.env.NODE_ENV !== 'production',
  migrations: [join(__dirname, '../database/migrations/*{.ts,.js}')],
});
