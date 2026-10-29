import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsInt, IsPositive, IsUUID } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateDepositDto {
  @ApiProperty({ description: 'ID xe cần đặt cọc', format: 'uuid' })
  @IsUUID()
  vehicleId: string;

  @ApiProperty({ description: 'Số tiền đặt cọc (VND)', example: 20000000 })
  @Type(() => Number) @IsInt() @IsPositive()
  amountVnd: number;

  @ApiProperty({ enum: ['transfer', 'qr'], description: 'Phương thức chuyển khoản' })
  @IsIn(['transfer', 'qr'])
  method: 'transfer' | 'qr';
}
