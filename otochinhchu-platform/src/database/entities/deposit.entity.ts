import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index, ManyToOne, JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Vehicle } from './vehicle.entity';

export enum DepositStatus {
  PENDING_PAYMENT = 'pending_payment',
  VERIFYING = 'verifying',
  PAID = 'paid',
  DISPUTED = 'disputed',
  REFUNDED = 'refunded',
}

@Entity({ name: 'deposits' })
@Index(['status'])
export class Deposit {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'reference_code', type: 'varchar', length: 30, unique: true })
  referenceCode: string;

  @ManyToOne(() => User, { nullable: false, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'buyer_id' })
  buyer: User;

  @Column({ name: 'buyer_id', type: 'uuid' })
  buyerId: string;

  @ManyToOne(() => Vehicle, { nullable: false, onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'vehicle_id' })
  vehicle: Vehicle;

  @Column({ name: 'vehicle_id', type: 'uuid' })
  vehicleId: string;

  @Column({ name: 'amount_vnd', type: 'bigint' })
  amountVnd: number;

  @Column({ type: 'enum', enum: DepositStatus, default: DepositStatus.PENDING_PAYMENT })
  status: DepositStatus;

  @Column({ name: 'payment_reference', type: 'varchar', length: 100, nullable: true })
  paymentReference: string;

  @Column({ name: 'confirmed_at', type: 'timestamptz', nullable: true })
  confirmedAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
