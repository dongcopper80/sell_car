import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Deposit, DepositStatus, UserRole } from '../../database/entities';
import { DEPOSIT_STATUS_FLOW } from '../../database/entities/audit-log.entity';
import { CreateDepositDto } from './dto/create-deposit.dto';
import { AuditService } from '../audit/audit.service';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class DepositsService {
  constructor(
    @InjectRepository(Deposit) private readonly depositsRepository: Repository<Deposit>,
    private readonly auditService: AuditService,
    private readonly notifications: NotificationsService,
  ) { }

  /** Người mua tạo yêu cầu đặt cọc → Pending Payment. Không tự xác nhận Paid. */
  async create(dto: CreateDepositDto, buyer: { userId: string }) {
    const reference = `DEP-${Date.now().toString().slice(-8)}`;
    const deposit = await this.depositsRepository.save({
      ...dto,
      referenceCode: reference,
      buyerId: buyer.userId,
      status: DepositStatus.PENDING_PAYMENT,
    });
    await this.notifications.create(
      buyer.userId,
      'Đã tạo yêu cầu đặt cọc',
      `Yêu cầu ${reference} đang chờ bạn chuyển khoản. Mã tham chiếu: ${reference}.`,
      `/deposits/${deposit.id}`,
    );
    return deposit;
  }

  findAll(status?: DepositStatus) {
    return this.depositsRepository.find({
      where: status ? { status } : {},
      order: { createdAt: 'DESC' },
    });
  }

  findMine(userId: string) {
    return this.depositsRepository.find({ where: { buyerId: userId }, order: { createdAt: 'DESC' } });
  }

  async findOne(id: string, user: { userId: string; role: string }) {
    const deposit = await this.depositsRepository.findOne({ where: { id } });
    if (!deposit) throw new NotFoundException(`Deposit ${id} not found`);
    if (deposit.buyerId !== user.userId && user.role !== UserRole.ADMIN) throw new ForbiddenException();
    return deposit;
  }

  /** CMS nhận chứng từ: Pending → Verifying */
  async markProofReceived(id: string, admin: { userId: string; role: string }, paymentReference: string) {
    return this.transition(id, DepositStatus.VERIFYING, admin, paymentReference);
  }

  /** CMS xác nhận đã đối soát tiền: Verifying → Paid */
  async confirmPaid(id: string, admin: { userId: string; role: string }, paymentReference: string) {
    return this.transition(id, DepositStatus.PAID, admin, paymentReference);
  }

  private async transition(
    id: string,
    next: DepositStatus,
    admin: { userId: string; role: string },
    paymentReference?: string,
  ) {
    if (admin.role !== UserRole.ADMIN) throw new ForbiddenException('Chỉ admin được xác nhận đặt cọc');
    const deposit = await this.depositsRepository.findOne({ where: { id } });
    if (!deposit) throw new NotFoundException(`Deposit ${id} not found`);
    const allowed = DEPOSIT_STATUS_FLOW[deposit.status] ?? [];
    if (!allowed.includes(next)) {
      throw new ForbiddenException(`Không thể chuyển từ ${deposit.status} sang ${next}`);
    }
    deposit.status = next;
    if (paymentReference) deposit.paymentReference = paymentReference;
    if (next === DepositStatus.PAID) deposit.confirmedAt = new Date();
    await this.auditService.log('deposit.confirm', 'deposit', id, admin.userId, {
      from: deposit.status,
      to: next,
      paymentReference,
    });
    await this.notifications.create(
      deposit.buyerId,
      next === DepositStatus.PAID ? 'Đã xác nhận đặt cọc' : 'Đã nhận chứng từ đặt cọc',
      `Yêu cầu ${deposit.referenceCode} chuyển sang trạng thái ${next}.`,
      `/deposits/${deposit.id}`,
    );
    return this.depositsRepository.save(deposit);
  }
}

