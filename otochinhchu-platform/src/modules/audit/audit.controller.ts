import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuditService } from './audit.service';
import { JwtAuthGuard, Roles, RolesGuard } from '../../common';

@ApiTags('cms/audit')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
@Controller('cms/audit')
export class AuditController {
  constructor(private readonly auditService: AuditService) { }

  @Get()
  list(@Query('limit') limit?: number) {
    return this.auditService.findRecent(limit ? Number(limit) : 100);
  }
}
