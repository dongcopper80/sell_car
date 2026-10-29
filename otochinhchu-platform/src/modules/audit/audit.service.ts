import { Injectable } from '@nestjs/common';
import { AuditLog, AuditAction } from '../../database/entities';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class AuditService {
  constructor(
    @InjectRepository(AuditLog) private readonly auditRepository: Repository<AuditLog>,
  ) { }

  log(
    action: AuditAction | string,
    entityType: string,
    entityId: string,
    actorId: string | null,
    payload?: Record<string, unknown>,
    ip?: string,
  ) {
    return this.auditRepository.save({
      action: action as AuditAction,
      entityType,
      entityId,
      actorId,
      payload,
      ip,
    });
  }

  findRecent(limit = 100) {
    return this.auditRepository.find({ order: { createdAt: 'DESC' }, take: limit });
  }
}
