import {
  Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index,
} from 'typeorm';

/** Trang nội dung CMS: chính sách, điều khoản, hướng dẫn (legal/content) */
@Entity({ name: 'content_pages' })
@Index(['slug'], { unique: true })
export class ContentPage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 120 })
  slug: string;

  @Column({ type: 'varchar', length: 200 })
  title: string;

  @Column({ type: 'text', nullable: true })
  summary: string;

  @Column({ type: 'text', nullable: true })
  body: string;

  @Column({ type: 'varchar', length: 40, default: 'legal' })
  category: string;

  @Column({ type: 'varchar', length: 20, default: 'published' })
  status: 'draft' | 'published' | 'archived';

  @Column({ name: 'updated_by_id', type: 'uuid', nullable: true })
  updatedById: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
