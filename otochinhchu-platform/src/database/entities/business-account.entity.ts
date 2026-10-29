import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index, ManyToOne, JoinColumn, OneToMany,
} from 'typeorm';
import { User, UserRole, AccountStatus } from './user.entity';
import { BusinessDocument } from './business-document.entity';

/**
 * Hồ sơ doanh nghiệp/salon.
 * Chỉ nhân viên CMS tạo thủ công sau khi đối chiếu giấy tờ (không có self-signup).
 */
@Entity({ name: 'business_accounts' })
@Index(['status'])
export class BusinessAccount {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  /** Mã hiển thị dạng DN-000123 */
  @Column({ type: 'varchar', length: 20, unique: true })
  code: string;

  @ManyToOne(() => User, { nullable: false, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'owner_id' })
  owner: User;

  @Column({ name: 'owner_id', type: 'uuid' })
  ownerId: string;

  @Column({ type: 'varchar', length: 200 })
  companyName: string;

  @Column({ name: 'business_license_number', type: 'varchar', length: 50 })
  @Index({ unique: true })
  businessLicenseNumber: string;

  @Column({ name: 'tax_code', type: 'varchar', length: 20 })
  @Index({ unique: true })
  taxCode: string;

  @Column({ name: 'representative_name', type: 'varchar', length: 150 })
  representativeName: string;

  @Column({ type: 'varchar', length: 180 })
  email: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  phone: string;

  @Column({ type: 'varchar', length: 255 })
  address: string;

  @Column({ name: 'bank_name', type: 'varchar', length: 150 })
  bankName: string;

  @Column({ name: 'bank_account_number', type: 'varchar', length: 30 })
  bankAccountNumber: string;

  @Column({ name: 'bank_account_holder', type: 'varchar', length: 150 })
  bankAccountHolder: string;

  @Column({ type: 'boolean', default: false })
  documentsVerified: boolean;

  /** Thời điểm CMS đối chiếu xong hồ sơ */
  @Column({ name: 'verified_at', type: 'timestamptz', nullable: true })
  verifiedAt: Date;

  /** Người CMS tạo (audit) */
  @Column({ name: 'created_by_id', type: 'uuid', nullable: true })
  createdById: string;

  @Column({ type: 'enum', enum: AccountStatus, default: AccountStatus.PENDING })
  status: AccountStatus;

  @OneToMany(() => BusinessDocument, (doc) => doc.businessAccount)
  documents: BusinessDocument[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
