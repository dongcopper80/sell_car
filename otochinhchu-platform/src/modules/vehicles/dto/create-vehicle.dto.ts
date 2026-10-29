import {
  ApiProperty, ApiPropertyOptional,
} from '@nestjs/swagger';
import {
  IsIn, IsInt, IsNotEmpty, IsOptional, IsPositive, IsString, IsUUID, MaxLength, Min, ArrayNotEmpty,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateVehicleDto {
  @ApiProperty({ description: 'Tiêu đề tin đăng', example: 'Toyota Corolla Cross 1.8V 2023 màu trắng', maxLength: 200 })
  @IsString() @IsNotEmpty() @MaxLength(200)
  title: string;

  @ApiProperty({ description: 'ID hãng xe (catalog/makes)', format: 'uuid' })
  @IsUUID()
  makeId: string;

  @ApiProperty({ description: 'ID dòng xe (catalog/models)', format: 'uuid' })
  @IsUUID()
  modelId: string;

  @ApiProperty({ example: 2023, minimum: 1990 })
  @Type(() => Number) @IsInt() @Min(1990)
  year: number;

  @ApiProperty({ description: 'Số km đã đi', example: 18000, minimum: 0 })
  @Type(() => Number) @IsInt() @Min(0)
  odometerKm: number;

  @ApiProperty({ enum: ['manual', 'automatic'], description: 'Hộp số' })
  @IsIn(['manual', 'automatic'])
  transmission: 'manual' | 'automatic';

  @ApiProperty({ enum: ['petrol', 'diesel', 'electric', 'hybrid'], description: 'Nhiên liệu' })
  @IsIn(['petrol', 'diesel', 'electric', 'hybrid'])
  fuelType: 'petrol' | 'diesel' | 'electric' | 'hybrid';

  @ApiProperty({ description: 'Giá bán (VND)', example: 820000000 })
  @Type(() => Number) @IsInt() @IsPositive()
  priceVnd: number;

  @ApiProperty({ description: 'Địa điểm chi tiết', example: 'Quận Cầu Giấy, Hà Nội', maxLength: 120 })
  @IsString() @IsNotEmpty() @MaxLength(120)
  location: string;

  @ApiProperty({ description: 'Mã tỉnh/thành (catalog/provinces)', example: '01' })
  @IsString() @MaxLength(10)
  provinceCode: string;

  @ApiPropertyOptional({ description: 'Mô tả chi tiết' })
  @IsOptional() @IsString()
  description?: string;

  @ApiProperty({ type: [String], description: 'Danh sách URL ảnh (upload nội bộ hoặc link bên ngoài)', example: ['https://images.unsplash.com/photo-xxx'] })
  @ArrayNotEmpty()
  @IsString({ each: true })
  photos: string[];
}
