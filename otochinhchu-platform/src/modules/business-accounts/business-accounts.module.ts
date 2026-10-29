import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BusinessAccount, BusinessDocument } from '../../database/entities';
import { BusinessAccountsService } from './business-accounts.service';
import { BusinessAccountsController } from './business-accounts.controller';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [TypeOrmModule.forFeature([BusinessAccount, BusinessDocument]), AuditModule],
  controllers: [BusinessAccountsController],
  providers: [BusinessAccountsService],
  exports: [BusinessAccountsService],
})
export class BusinessAccountsModule { }
