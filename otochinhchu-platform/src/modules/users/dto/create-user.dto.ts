import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEmail, IsIn, IsMobilePhone, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateUserDto {
  @ApiProperty({ example: 'nguoi-mua@example.com', format: 'email' })
  @IsEmail()
  email: string;

  @ApiPropertyOptional({ example: '0901234567' })
  @IsOptional()
  @IsMobilePhone('vi-VN')
  phone?: string;

  @ApiProperty({ example: 'Nguyễn Văn A', maxLength: 150 })
  @IsString()
  @MaxLength(150)
  fullName: string;

  @ApiPropertyOptional({ enum: ['buyer', 'seller_personal', 'business'], default: 'buyer' })
  @IsOptional()
  @IsIn(['buyer', 'seller_personal', 'business'])
  role?: 'buyer' | 'seller_personal' | 'business';

  @ApiPropertyOptional({ example: '12 Nguyễn Trãi, Cầu Giấy, Hà Nội' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  address?: string;
}
