import { PartialType } from '@nestjs/swagger';
import { CreateBusinessAccountDto } from './create-business-account.dto';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';
import { AccountStatus } from '../../../database/entities';

export class UpdateBusinessAccountDto extends PartialType(CreateBusinessAccountDto) {
  @ApiPropertyOptional({ enum: AccountStatus })
  @IsOptional()
  @IsEnum(AccountStatus)
  status?: AccountStatus;

  @ApiPropertyOptional()
  @IsOptional() @IsString() @MaxLength(300)
  statusNote?: string;
}
