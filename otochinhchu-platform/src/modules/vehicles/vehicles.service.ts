import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Vehicle, VehicleStatus, User, UserRole } from '../../database/entities';
import { VEHICLE_STATUS_FLOW } from '../../database/entities/audit-log.entity';
import { CreateVehicleDto } from './dto/create-vehicle.dto';
import { UpdateVehicleDto } from './dto/update-vehicle.dto';
import { AuditService } from '../audit/audit.service';

@Injectable()
export class VehiclesService {
  constructor(
    @InjectRepository(Vehicle) private readonly vehiclesRepository: Repository<Vehicle>,
    private readonly auditService: AuditService,
  ) { }

  async create(dto: CreateVehicleDto, user: { userId: string; role: string }) {
    const sellerType: 'business' | 'personal' = user.role === UserRole.BUSINESS ? 'business' : 'personal';
    const vehicle = this.vehiclesRepository.create({
      ...dto,
      sellerId: user.userId,
      sellerType,
      status: VehicleStatus.DRAFT,
    } as any);
    return this.vehiclesRepository.save(vehicle);
  }

  /** Trang chủ / tìm kiếm: chỉ trả tin Published */
  findPublic(filters: {
    keyword?: string;
    provinceCode?: string;
    fuelType?: string;
    transmission?: string;
    minPrice?: number;
    maxPrice?: number;
    page?: number;
    pageSize?: number;
  }) {
    const qb = this.vehiclesRepository
      .createQueryBuilder('v')
      .where('v.status = :status', { status: VehicleStatus.PUBLISHED });

    if (filters.keyword) {
      qb.andWhere('(LOWER(v.title) LIKE :kw OR LOWER(v.location) LIKE :kw)', {
        kw: `%${filters.keyword.toLowerCase()}%`,
      });
    }
    if (filters.provinceCode) qb.andWhere('v.provinceCode = :provinceCode', { provinceCode: filters.provinceCode });
    if (filters.fuelType) qb.andWhere('v.fuelType = :fuelType', { fuelType: filters.fuelType });
    if (filters.transmission) qb.andWhere('v.transmission = :transmission', { transmission: filters.transmission });
    if (filters.minPrice) qb.andWhere('v.priceVnd >= :minPrice', { minPrice: filters.minPrice });
    if (filters.maxPrice) qb.andWhere('v.priceVnd <= :maxPrice', { maxPrice: filters.maxPrice });

    const page = Math.max(1, filters.page ?? 1);
    const pageSize = Math.min(50, Math.max(1, filters.pageSize ?? 20));
    qb.orderBy('v.createdAt', 'DESC')
      .skip((page - 1) * pageSize)
      .take(pageSize);

    return qb.getManyAndCount().then(([items, total]) => ({ items, total, page, pageSize }));
  }

  async findOne(id: string, user?: { userId: string; role: string }): Promise<Vehicle> {
    const vehicle = await this.vehiclesRepository.findOne({ where: { id } });
    if (!vehicle) throw new NotFoundException(`Vehicle ${id} not found`);

    const isOwner = vehicle.sellerId === user?.userId;
    const isAdmin = user?.role === UserRole.ADMIN;
    if (vehicle.status !== VehicleStatus.PUBLISHED && !isOwner && !isAdmin) {
      throw new NotFoundException(`Vehicle ${id} not found`);
    }
    await this.vehiclesRepository.increment({ id }, 'viewCount', 1);
    return vehicle;
  }

  async findMine(userId: string): Promise<Vehicle[]> {
    return this.vehiclesRepository.find({ where: { sellerId: userId }, order: { createdAt: 'DESC' } });
  }

  async update(id: string, dto: UpdateVehicleDto, user: { userId: string; role: string }): Promise<Vehicle> {
    const vehicle = await this.findOne(id, user);
    if (vehicle.sellerId !== user.userId && user.role !== UserRole.ADMIN) {
      throw new ForbiddenException('Chỉ chủ tin hoặc admin được sửa');
    }
    Object.assign(vehicle, dto);
    return this.vehiclesRepository.save(vehicle);
  }

  async submitForReview(id: string, user: { userId: string; role: string }) {
    const vehicle = await this.findOne(id, user);
    if (vehicle.sellerId !== user.userId && user.role !== UserRole.ADMIN) throw new ForbiddenException();
    await this.assertTransition(vehicle, VehicleStatus.PENDING_REVIEW);
    vehicle.status = VehicleStatus.PENDING_REVIEW;
    return this.vehiclesRepository.save(vehicle);
  }

  /** CMS: duyệt / từ chối */
  async moderate(id: string, action: 'approve' | 'reject', moderator: { userId: string }, note?: string) {
    const vehicle = await this.findOne(id);
    const next = action === 'approve' ? VehicleStatus.PUBLISHED : VehicleStatus.REJECTED;
    await this.assertTransition(vehicle, next);
    vehicle.status = next;
    vehicle.moderatedById = moderator.userId;
    vehicle.moderationNote = note ?? null;
    vehicle.verified = action === 'approve';
    await this.auditService.log(
      'vehicle.moderate',
      'vehicle',
      id,
      moderator.userId,
      { action, note },
    );
    return this.vehiclesRepository.save(vehicle);
  }

  async changeStatus(id: string, status: VehicleStatus, actor: { userId: string }) {
    const vehicle = await this.findOne(id);
    await this.assertTransition(vehicle, status);
    vehicle.status = status;
    await this.auditService.log('vehicle.moderate', 'vehicle', id, actor.userId, { status });
    return this.vehiclesRepository.save(vehicle);
  }

  async remove(id: string, user: { userId: string; role: string }) {
    const vehicle = await this.findOne(id, user);
    if (vehicle.sellerId !== user.userId && user.role !== UserRole.ADMIN) throw new ForbiddenException();
    await this.vehiclesRepository.delete(id);
  }

  /** Kiểm tra luồng trạng thái, chặn nhảy cóc */
  private async assertTransition(vehicle: Vehicle, next: VehicleStatus) {
    const allowed = VEHICLE_STATUS_FLOW[vehicle.status] ?? [];
    if (!allowed.includes(next)) {
      throw new ForbiddenException(`Không thể chuyển từ ${vehicle.status} sang ${next}`);
    }
  }
}

