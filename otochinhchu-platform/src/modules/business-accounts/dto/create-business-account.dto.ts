import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray, IsBoolean, IsEmail, IsEnum, IsNotEmpty, IsOptional, IsString, MaxLength, ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { BusinessDocType } from '../../../database/entities/business-document.entity';

export class BusinessDocumentInputDto {
  @ApiProperty({ enum: BusinessDocType })
  @IsEnum(BusinessDocType)
  docType: BusinessDocType;

  @ApiProperty()
  @IsString() @MaxLength(500)
  fileUrl: string;

  @ApiPropertyOptional()
  @IsOptional() @IsString()
  note?: string;
}

export class CreateBusinessAccountDto {
  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(200)
  companyName: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(50)
  businessLicenseNumber: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(20)
  taxCode: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(150)
  representativeName: string;

  @ApiProperty()
  @IsEmail()
  email: string;

  @ApiPropertyOptional()
  @IsOptional() @IsString() @MaxLength(20)
  phone?: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(255)
  address: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(150)
  bankName: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(30)
  bankAccountNumber: string;

  @ApiProperty()
  @IsString() @IsNotEmpty() @MaxLength(150)
  bankAccountHolder: string;

  /** UUID của user (đã tồn tại) sẽ được gán làm owner */
  @ApiProperty()
  @IsString() @IsNotEmpty()
  ownerId: string;

  @ApiPropertyOptional({ type: [BusinessDocumentInputDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BusinessDocumentInputDto)
  documents?: BusinessDocumentInputDto[];

  /** CMS xác nhận đã đối chiếu đủ giấy tờ bắt buộc */
  @ApiProperty()
  @IsBoolean()
  documentsVerified: boolean;
}
