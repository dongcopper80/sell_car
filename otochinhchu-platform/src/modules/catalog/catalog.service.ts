import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CatalogItem } from '../../database/entities';

@Injectable()
export class CatalogService {
  constructor(
    @InjectRepository(CatalogItem) private readonly catalogRepository: Repository<CatalogItem>,
  ) { }

  findByGroup(groupCode: string) {
    return this.catalogRepository.find({ where: { groupCode, isActive: true }, order: { sortOrder: 'ASC' } });
  }

  async findOne(id: string) {
    const item = await this.catalogRepository.findOne({ where: { id } });
    if (!item) throw new NotFoundException(`Catalog item ${id} not found`);
    return item;
  }

  create(data: Partial<CatalogItem>) {
    return this.catalogRepository.save(data);
  }

  async update(id: string, data: Partial<CatalogItem>) {
    await this.catalogRepository.update(id, data);
    return this.findOne(id);
  }

  async remove(id: string) {
    await this.findOne(id);
    await this.catalogRepository.delete(id);
  }

  /** Danh sách nhóm đang có dữ liệu + số mục, dùng cho trang quản trị */
  async groups() {
    const rows = await this.catalogRepository
      .createQueryBuilder('ci')
      .select('ci.groupCode', 'groupCode')
      .addSelect('COUNT(*)', 'count')
      .groupBy('ci.groupCode')
      .orderBy('ci.groupCode', 'ASC')
      .getRawMany();
    return rows.map((r) => ({ groupCode: r.groupCode, count: Number(r.count) }));
  }
}
