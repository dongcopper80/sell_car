import { Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post, Query, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ContentPagesService } from './content-pages.service';
import { JwtAuthGuard, Roles, RolesGuard } from '../../common';

@ApiTags('cms/content')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
@Controller('cms/content')
export class ContentPagesController {
  constructor(private readonly service: ContentPagesService) {}

  @Get()
  findAll(@Query('category') category?: string) {
    return this.service.findAll(category);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.service.findOne(id);
  }

  @Post()
  create(@Body() body: { slug: string; title: string; summary?: string; body?: string; category?: string; status?: string }, @Request() req) {
    return this.service.create(body as any, req.user.userId);
  }

  @Patch(':id')
  update(@Param('id', ParseUUIDPipe) id: string, @Body() body: Record<string, string>, @Request() req) {
    return this.service.update(id, body, req.user.userId);
  }

  @Delete(':id')
  remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.service.remove(id);
  }
}
