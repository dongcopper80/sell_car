import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ContentPage } from '../../database/entities';

@Injectable()
export class ContentPagesService {
  constructor(
    @InjectRepository(ContentPage) private readonly repo: Repository<ContentPage>,
  ) { }

  findAll(category?: string) {
    return this.repo.find({
      where: category ? { category } : {},
      order: { category: 'ASC', title: 'ASC' },
    });
  }

  async findOne(id: string) {
    const page = await this.repo.findOne({ where: { id } });
    if (!page) throw new NotFoundException(`Content page ${id} not found`);
    return page;
  }

  create(data: Partial<ContentPage> & { slug: string; title: string }, adminId: string) {
    return this.repo.save({ ...data, updatedById: adminId });
  }

  async update(id: string, data: Partial<ContentPage>, adminId: string) {
    await this.repo.update(id, { ...data, updatedById: adminId });
    return this.findOne(id);
  }

  async remove(id: string) {
    await this.findOne(id);
    await this.repo.delete(id);
  }
}
