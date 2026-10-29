import { Body, Controller, Get, Param, ParseUUIDPipe, Patch, Post, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { BusinessAccountsService } from './business-accounts.service';
import { CreateBusinessAccountDto } from './dto/create-business-account.dto';
import { UpdateBusinessAccountDto } from './dto/update-business-account.dto';
import { JwtAuthGuard, Roles, RolesGuard } from '../../common';
import { AccountStatus } from '../../database/entities';

@ApiTags('cms/business-accounts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
@Controller('cms/business-accounts')
export class BusinessAccountsController {
  constructor(private readonly service: BusinessAccountsService) { }

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.service.findOne(id);
  }

  /** Tạo tài khoản doanh nghiệp sau khi đối chiếu giấy tờ */
  @Post()
  create(@Body() dto: CreateBusinessAccountDto, @Request() req) {
    return this.service.create(dto, req.user);
  }

  @Patch(':id/status')
  changeStatus(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() body: { status: 'active' | 'suspended' | 'pending'; note?: string },
    @Request() req,
  ) {
    return this.service.changeStatus(id, body.status as AccountStatus, req.user, body.note);
  }
}

