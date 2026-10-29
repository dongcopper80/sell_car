import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index,
} from 'typeorm';

export enum UserRole {
  BUYER = 'buyer',
  SELLER_PERSONAL = 'seller_personal',
  BUSINESS = 'business',
  ADMIN = 'admin',
}

export enum AccountStatus {
  ACTIVE = 'active',
  PENDING = 'pending',
  SUSPENDED = 'suspended',
}

@Entity({ name: 'users' })
@Index(['role', 'status'])
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 180, unique: true, nullable: true })
  @Index()
  email: string;

  @Column({ type: 'varchar', length: 20, unique: true, nullable: true })
  @Index()
  phone: string;

  @Column({ type: 'varchar', length: 150 })
  fullName: string;

  /** bcrypt hash; null khi tài khoản đăng nhập qua VNeID */
  @Column({ type: 'varchar', length: 100, nullable: true, select: false })
  passwordHash?: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.BUYER })
  role: UserRole;

  @Column({ type: 'enum', enum: AccountStatus, default: AccountStatus.ACTIVE })
  status: AccountStatus;

  /** Định danh cá nhân đã xác thực qua VNeID */
  @Column({ type: 'boolean', default: false })
  identityVerified: boolean;

  @Column({ type: 'varchar', length: 64, unique: true, nullable: true })
  @Index()
  vneidToken: string;

  @Column({ type: 'varchar', length: 12, nullable: true })
  cccd?: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  avatarUrl?: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  address?: string;

  /** Mã tỉnh/thành dùng cho tìm kiếm theo khu vực */
  @Column({ type: 'varchar', length: 10, nullable: true })
  provinceCode?: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
