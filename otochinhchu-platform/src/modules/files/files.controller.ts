import { Controller, Post, UploadedFiles, UseGuards, UseInterceptors } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { FilesService } from './files.service';
import { JwtAuthGuard, RolesGuard } from '../../common';

@ApiTags('files')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('files')
export class FilesController {
  constructor(private readonly filesService: FilesService) { }

  @ApiConsumes('multipart/form-data')
  @Post('upload')
  @UseInterceptors(FilesInterceptor('files', 10, FilesService.multerOptions()))
  upload(@UploadedFiles() files: Express.Multer.File[]) {
    return files.map((f) => this.filesService.publicUrl(f.filename));
  }
}
