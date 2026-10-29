import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, ManyToOne, JoinColumn, Index,
} from 'typeorm';
import { BusinessAccount } from './business-account.entity';

export enum BusinessDocType {
  BUSINESS_LICENSE = 'business_license',
  TAX_CODE = 'tax_code',
  BANK_CONFIRMATION = 'bank_confirmation',
  REPRESENTATIVE_ID = 'representative_id',
  AUTHORIZATION_LETTER = 'authorization_letter',
}

/** Bằng chứng đối chiếu hồ sơ; ảnh lưu trên file storage, DB chỉ giữ URL. */
@Entity({ name: 'business_documents' })
@Index(['businessAccountId', 'docType'], { unique: true })
export class BusinessDocument {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => BusinessAccount, (acc) => acc.documents, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'business_account_id' })
  businessAccount: BusinessAccount;

  @Column({ name: 'business_account_id', type: 'uuid' })
  businessAccountId: string;

  @Column({ name: 'doc_type', type: 'enum', enum: BusinessDocType })
  docType: BusinessDocType;

  @Column({ type: 'varchar', length: 500 })
  fileUrl: string;

  /** CMS xác nhận đã đối chiếu giấy tờ này */
  @Column({ type: 'boolean', default: false })
  verified: boolean;

  @Column({ name: 'verified_by_id', type: 'uuid', nullable: true })
  verifiedById: string;

  @Column({ type: 'varchar', length: 300, nullable: true })
  note: string;

  @CreateDateColumn()
  createdAt: Date;
}
