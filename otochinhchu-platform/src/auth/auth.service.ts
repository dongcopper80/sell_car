import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import { Repository } from 'typeorm';
import { User } from '../database/entities/user.entity';
import { JwtPayload } from './dto/jwt-payload.interface';
import { CreateUserDto } from '../modules/users/dto/create-user.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private readonly usersRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) { }

  async register(dto: CreateUserDto) {
    const exists = await this.usersRepository.findOne({ where: { email: dto.email } });
    if (exists) throw new UnauthorizedException('Email đã tồn tại');
    const user = await this.usersRepository.save({
      ...dto,
      passwordHash: await bcrypt.hash((dto as any).password ?? Math.random().toString(36), 10),
    } as any);
    return this.signToken(user);
  }

  async login(email: string, password: string) {
    const user = await this.usersRepository.findOne({
      where: { email },
      select: ['id', 'email', 'passwordHash', 'role', 'status'],
    });
    if (!user || !(await bcrypt.compare(password, user.passwordHash ?? ''))) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }
    if (user.status !== 'active') throw new UnauthorizedException('Tài khoản chưa kích hoạt');
    return this.signToken(user);
  }

  /**
   * VNeID (VNeID/CSDL) OAuth flow.
   * - Bước 1: redirect tới VNeID authorize (client làm)
   * - Bước 2: callback nhận code, đổi token, mapping user
   */
  async vneidCallback(code: string) {
    // TODO: gọi API VNeID thực tế để lấy thông tin user từ code.
    // Ở MVP ta giả lập: mã code định danh là email.
    const mockEmail = `vneid_${code}@otochinhchu.vn`;
    let user = await this.usersRepository.findOne({ where: { email: mockEmail } });
    if (!user) {
      user = await this.usersRepository.save({
        email: mockEmail,
        fullName: `Người dùng VNeID ${code}`,
        identityVerified: true,
        vneidToken: code,
      });
    }
    return this.signToken(user);
  }

  private signToken(user: User) {
    const payload: JwtPayload = { sub: user.id, email: user.email, role: user.role };
    return {
      accessToken: this.jwtService.sign(payload),
      user: { id: user.id, email: user.email, role: user.role, fullName: user.fullName },
    };
  }
}
