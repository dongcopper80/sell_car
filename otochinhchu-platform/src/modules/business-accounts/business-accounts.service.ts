import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AccountStatus, AuditAction, BusinessAccount, BusinessDocument, BusinessDocType, User, UserRole } from '../../database/entities';
import { ACCOUNT_STATUS_FLOW } from '../../database/entities/audit-log.entity';
import { CreateBusinessAccountDto } from './dto/create-business-account.dto';
import { UpdateBusinessAccountDto } from './dto/update-business-account.dto';
import { AuditService } from '../audit/audit.service';

const REQUIRED_DOCS: BusinessDocType[] = [
  BusinessDocType.BUSINESS_LICENSE,
  BusinessDocType.TAX_CODE,
  BusinessDocType.BANK_CONFIRMATION,
  BusinessDocType.REPRESENTATIVE_ID,
];

@Injectable()
export class BusinessAccountsService {
  constructor(
    @InjectRepository(BusinessAccount)
    private readonly accountsRepository: Repository<BusinessAccount>,
    @InjectRepository(BusinessDocument)
    private readonly documentsRepository: Repository<BusinessDocument>,
    private readonly auditService: AuditService,
    private readonly dataSource: DataSource,
  ) { }

  /**
   * Chỉ CMS (admin) tạo tài khoản doanh nghiệp, sau khi đối chiếu giấy tờ.
   * Luồng: tạo account + documents trong 1 transaction, ghi audit log.
   */
  async create(dto: CreateBusinessAccountDto, admin: { userId: string; role: string }) {
    if (admin.role !== UserRole.ADMIN) throw new ForbiddenException('Chỉ admin được tạo tài khoản doanh nghiệp');
    if (!dto.documentsVerified) throw new ForbiddenException('Phải xác nhận đã đối chiếu giấy tờ trước khi tạo');

    const user = await this.dataSource.getRepository(User).findOne({ where: { id: dto.ownerId } });
    if (!user) throw new NotFoundException('Không tìm thấy người dùng chủ tài khoản');

    const providedTypes = new Set((dto.documents ?? []).map((d) => d.docType));
    const missing = REQUIRED_DOCS.filter((t) => !providedTypes.has(t));
    if (missing.length) {
      throw new ForbiddenException(`Thiếu giấy tờ bắt buộc: ${missing.join(', ')}`);
    }

    const code = await this.nextCode();
    return this.dataSource.transaction(async (em) => {
      const account = await em.getRepository(BusinessAccount).save({
        ...dto,
        code,
        ownerId: dto.ownerId,
        createdById: admin.userId,
        status: AccountStatus.ACTIVE,
        verifiedAt: new Date(),
      });
      const docs = (dto.documents ?? []).map((d) =>
        em.getRepository(BusinessDocument).create({
          businessAccountId: account.id,
          docType: d.docType,
          fileUrl: d.fileUrl,
          note: d.note ?? null,
          verified: true,
          verifiedById: admin.userId,
        }),
      );
      await em.getRepository(BusinessDocument).save(docs);
      await this.auditService.log('business_account.create', 'business_account', account.id, admin.userId, {
        code,
        companyName: dto.companyName,
        taxCode: dto.taxCode,
      });
      return account;
    });
  }

  findAll(): Promise<BusinessAccount[]> {
    return this.accountsRepository.find({ relations: ['documents'], order: { createdAt: 'DESC' } });
  }

  async findOne(id: string): Promise<BusinessAccount> {
    const account = await this.accountsRepository.findOne({ where: { id }, relations: ['documents'] });
    if (!account) throw new NotFoundException(`Business account ${id} not found`);
    return account;
  }

  /** Khoá / mở khoá tài khoản, ghi audit log và lưu note */
  async changeStatus(id: string, status: AccountStatus, admin: { userId: string; role: string }, note?: string) {
    if (admin.role !== UserRole.ADMIN) throw new ForbiddenException('Chỉ admin được đổi trạng thái');
    const account = await this.findOne(id);
    const allowed = ACCOUNT_STATUS_FLOW[account.status] ?? [];
    if (!allowed.includes(status)) {
      throw new ForbiddenException(`Không thể chuyển từ ${account.status} sang ${status}`);
    }
    account.status = status;
    await this.auditService.log('business_account.status', 'business_account', id, admin.userId, {
      from: account.status,
      to: status,
      note,
    });
  }

  private async nextCode(): Promise<string> {
    const result = await this.accountsRepository
      .createQueryBuilder('ba')
      .select('COUNT(*)', 'count')
      .getRawOne();
    const seq = Number(result?.count ?? 0) + 1;
    return `DN-${String(seq).padStart(6, '0')}`;
  }
}
