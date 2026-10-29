import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification, NotificationChannel } from '../../database/entities';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification) private readonly notificationsRepository: Repository<Notification>,
  ) { }

  create(userId: string, title: string, body?: string, link?: string, channel: NotificationChannel = NotificationChannel.IN_APP) {
    return this.notificationsRepository.save({ userId, title, body, link, channel });
  }

  findForUser(userId: string) {
    return this.notificationsRepository.find({ where: { userId }, order: { createdAt: 'DESC' }, take: 50 });
  }

  findAll() {
    return this.notificationsRepository.find({ order: { createdAt: 'DESC' }, take: 100 });
  }

  async markRead(id: string, userId: string) {
    await this.notificationsRepository.update({ id, userId }, { isRead: true });
  }
}
