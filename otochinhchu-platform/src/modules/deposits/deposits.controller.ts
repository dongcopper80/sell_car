import { Body, Controller, Get, Param, ParseUUIDPipe, Post, Query, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DepositsService } from './deposits.service';
import { CreateDepositDto } from './dto/create-deposit.dto';
import { JwtAuthGuard, Roles, RolesGuard } from '../../common';
import { DepositStatus } from '../../database/entities';

@ApiTags('deposits')
@Controller('deposits')
export class DepositsController {
  constructor(private readonly depositsService: DepositsService) { }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Post()
  create(@Body() dto: CreateDepositDto, @Request() req) {
    return this.depositsService.create(dto, req.user);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get('mine')
  findMine(@Request() req) {
    return this.depositsService.findMine(req.user.userId);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get()
  @Roles('admin')
  findAll(@Query('status') status?: DepositStatus) {
    return this.depositsService.findAll(status);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string, @Request() req) {
    return this.depositsService.findOne(id, req.user);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Post(':id/proof')
  markProofReceived(@Param('id', ParseUUIDPipe) id: string, @Body() body: { paymentReference: string }, @Request() req) {
    return this.depositsService.markProofReceived(id, req.user, body.paymentReference);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Post(':id/confirm-paid')
  confirmPaid(@Param('id', ParseUUIDPipe) id: string, @Body() body: { paymentReference: string }, @Request() req) {
    return this.depositsService.confirmPaid(id, req.user, body.paymentReference);
  }
}
