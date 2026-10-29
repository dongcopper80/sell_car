import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ContentPage } from '../../database/entities';
import { ContentPagesService } from './content-pages.service';
import { ContentPagesController } from './content-pages.controller';

@Module({
  imports: [TypeOrmModule.forFeature([ContentPage])],
  controllers: [ContentPagesController],
  providers: [ContentPagesService],
  exports: [ContentPagesService],
})
export class ContentPagesModule { }
