import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index,
} from 'typeorm';

/** Danh mục dùng chung (hãng xe, dòng xe, tỉnh/thành...) để dễ mở rộng Catalog */
@Entity({ name: 'catalog_items' })
@Index(['groupCode', 'code'], { unique: true })
export class CatalogItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  /** Nhóm: makes, models, fuels, transmissions, provinces... */
  @Column({ name: 'group_code', type: 'varchar', length: 40 })
  groupCode: string;

  @Column({ type: 'varchar', length: 60 })
  code: string;

  @Column({ name: 'parent_id', type: 'uuid', nullable: true })
  parentId: string;

  @Column({ type: 'varchar', length: 150 })
  name: string;

  @Column({ type: 'int', default: 0 })
  sortOrder: number;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @Column({ type: 'simple-json', nullable: true })
  metadata: Record<string, unknown>;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
