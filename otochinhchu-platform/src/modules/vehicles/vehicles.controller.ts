import {
  Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post, Query, Request, UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { VehiclesService } from './vehicles.service';
import { CreateVehicleDto } from './dto/create-vehicle.dto';
import { UpdateVehicleDto } from './dto/update-vehicle.dto';
import { JwtAuthGuard, Public, Roles, RolesGuard } from '../../common';

@ApiTags('vehicles')
@Controller('vehicles')
export class VehiclesController {
  constructor(private readonly vehiclesService: VehiclesService) { }

  @Public()
  @Get()
  findPublic(@Query() query: Record<string, string>) {
    return this.vehiclesService.findPublic({
      keyword: query.keyword,
      provinceCode: query.provinceCode,
      fuelType: query.fuelType,
      transmission: query.transmission,
      minPrice: query.minPrice ? Number(query.minPrice) : undefined,
      maxPrice: query.maxPrice ? Number(query.maxPrice) : undefined,
      page: query.page ? Number(query.page) : undefined,
      pageSize: query.pageSize ? Number(query.pageSize) : undefined,
    });
  }

  @Public()
  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string, @Request() req) {
    return this.vehiclesService.findOne(id, req.user);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Get('mine/listings')
  findMine(@Request() req) {
    return this.vehiclesService.findMine(req.user.userId);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Post()
  create(@Body() dto: CreateVehicleDto, @Request() req) {
    return this.vehiclesService.create(dto, req.user);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Patch(':id')
  update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateVehicleDto, @Request() req) {
    return this.vehiclesService.update(id, dto, req.user);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Post(':id/submit')
  submit(@Param('id', ParseUUIDPipe) id: string, @Request() req) {
    return this.vehiclesService.submitForReview(id, req.user);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Post(':id/moderate')
  moderate(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() body: { action: 'approve' | 'reject'; note?: string },
    @Request() req,
  ) {
    return this.vehiclesService.moderate(id, body.action, req.user, body.note);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Delete(':id')
  remove(@Param('id', ParseUUIDPipe) id: string, @Request() req) {
    return this.vehiclesService.remove(id, req.user);
  }
}
