import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index, ManyToOne, JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

export enum VehicleStatus {
  DRAFT = 'draft',
  PENDING_REVIEW = 'pending_review',
  PUBLISHED = 'published',
  REJECTED = 'rejected',
  SOLD = 'sold',
  EXPIRED = 'expired',
}

export enum SellerType {
  PERSONAL = 'personal',
  BUSINESS = 'business',
}

@Entity({ name: 'vehicles' })
@Index(['status', 'provinceCode'])
@Index(['makeId', 'modelId'])
export class Vehicle {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { nullable: false, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'seller_id' })
  seller: User;

  @Column({ name: 'seller_id', type: 'uuid' })
  sellerId: string;

  @Column({ name: 'seller_type', type: 'enum', enum: SellerType })
  sellerType: SellerType;

  @Column({ name: 'business_account_id', type: 'uuid', nullable: true })
  businessAccountId: string;

  @Column({ type: 'varchar', length: 200 })
  title: string;

  @Column({ name: 'make_id', type: 'uuid', nullable: true })
  makeId: string;

  @Column({ name: 'model_id', type: 'uuid', nullable: true })
  modelId: string;

  @Column({ type: 'int' })
  year: number;

  @Column({ type: 'int' })
  odometerKm: number;

  @Column({ type: 'varchar', length: 20 })
  transmission: string;

  @Column({ type: 'varchar', length: 20 })
  fuelType: string;

  @Column({ name: 'price_vnd', type: 'bigint' })
  priceVnd: number;

  @Column({ type: 'varchar', length: 120 })
  location: string;

  @Column({ name: 'province_code', type: 'varchar', length: 10 })
  provinceCode: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  /** Mảng URL ảnh, dùng simple-json để tránh join phức tạp trong MVP */
  @Column({ type: 'simple-json', nullable: true })
  photos: string[];

  @Column({ type: 'enum', enum: VehicleStatus, default: VehicleStatus.DRAFT })
  status: VehicleStatus;

  @Column({ type: 'boolean', default: false })
  verified: boolean;

  @Column({ name: 'moderated_by_id', type: 'uuid', nullable: true })
  moderatedById: string;

  @Column({ name: 'moderation_note', type: 'varchar', length: 300, nullable: true })
  moderationNote: string;

  @Column({ name: 'view_count', type: 'int', default: 0 })
  viewCount: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
