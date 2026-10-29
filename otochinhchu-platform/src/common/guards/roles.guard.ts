import { Injectable, SetMetadata } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { AppException } from '../exceptions/app.exception';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);

/**
 * JwtAuthGuard + kiểm tra role gắn qua @Roles(...)
 * Không khai báo @Roles => mọi user đã đăng nhập đều pass.
 */
@Injectable()
export class RolesGuard {
  constructor(private readonly reflector: Reflector) { }

  canActivate(context: any) {
    const required = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!required || required.length === 0) return true;

    const { user } = context.switchToHttp().getRequest();
    if (!user?.role) throw new AppException('FORBIDDEN', 'Không có quyền truy cập', 403);
    if (!required.includes(user.role)) {
      throw new AppException('FORBIDDEN', `Yêu cầu vai trò: ${required.join(', ')}`, 403);
    }
    return true;
  }
}
