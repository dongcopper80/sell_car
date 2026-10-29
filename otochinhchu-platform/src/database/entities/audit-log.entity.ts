import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index, ManyToOne, JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Vehicle, VehicleStatus } from './vehicle.entity';
import { Deposit, DepositStatus } from './deposit.entity';
import { BusinessAccount } from './business-account.entity';
import { AccountStatus } from './user.entity';

export enum AuditAction {
  BUSINESS_ACCOUNT_CREATE = 'business_account.create',
  BUSINESS_ACCOUNT_STATUS = 'business_account.status',
  VEHICLE_MODERATE = 'vehicle.moderate',
  DEPOSIT_CONFIRM = 'deposit.confirm',
  LOGIN = 'auth.login',
}

@Entity({ name: 'audit_logs' })
@Index(['entityType', 'entityId'])
export class AuditLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'actor_id' })
  actor: User;

  @Column({ name: 'actor_id', type: 'uuid', nullable: true })
  actorId: string;

  @Column({ name: 'action', type: 'enum', enum: AuditAction })
  action: AuditAction;

  @Column({ name: 'entity_type', type: 'varchar', length: 40 })
  entityType: string;

  @Column({ name: 'entity_id', type: 'varchar', length: 64 })
  entityId: string;

  @Column({ type: 'simple-json', nullable: true })
  payload: Record<string, unknown>;

  @Column({ name: 'ip', type: 'varchar', length: 45, nullable: true })
  ip: string;

  @CreateDateColumn()
  createdAt: Date;
}

export const AUDIT_ENTITY_MAP = {
  [AuditAction.BUSINESS_ACCOUNT_CREATE]: BusinessAccount,
  [AuditAction.BUSINESS_ACCOUNT_STATUS]: BusinessAccount,
  [AuditAction.VEHICLE_MODERATE]: Vehicle,
  [AuditAction.DEPOSIT_CONFIRM]: Deposit,
} as const;

export const VEHICLE_STATUS_FLOW: Record<VehicleStatus, VehicleStatus[]> = {
  [VehicleStatus.DRAFT]: [VehicleStatus.PENDING_REVIEW],
  [VehicleStatus.PENDING_REVIEW]: [VehicleStatus.PUBLISHED, VehicleStatus.REJECTED],
  [VehicleStatus.PUBLISHED]: [VehicleStatus.SOLD, VehicleStatus.EXPIRED],
  [VehicleStatus.REJECTED]: [VehicleStatus.DRAFT],
  [VehicleStatus.SOLD]: [],
  [VehicleStatus.EXPIRED]: [VehicleStatus.PUBLISHED],
};

export const DEPOSIT_STATUS_FLOW: Record<DepositStatus, DepositStatus[]> = {
  [DepositStatus.PENDING_PAYMENT]: [DepositStatus.VERIFYING, DepositStatus.DISPUTED],
  [DepositStatus.VERIFYING]: [DepositStatus.PAID, DepositStatus.DISPUTED, DepositStatus.REFUNDED],
  [DepositStatus.PAID]: [],
  [DepositStatus.DISPUTED]: [DepositStatus.REFUNDED, DepositStatus.VERIFYING],
  [DepositStatus.REFUNDED]: [],
};

export const ACCOUNT_STATUS_FLOW: Record<AccountStatus, AccountStatus[]> = {
  [AccountStatus.PENDING]: [AccountStatus.ACTIVE, AccountStatus.SUSPENDED],
  [AccountStatus.ACTIVE]: [AccountStatus.SUSPENDED],
  [AccountStatus.SUSPENDED]: [AccountStatus.ACTIVE],
};
