import { HttpException, HttpStatus } from '@nestjs/common';

/** Chuẩn hóa lỗi: mọi module ném AppException(code, message, status) */
export class AppException extends HttpException {
  constructor(
    public readonly code: string,
    message: string,
    status: HttpStatus = HttpStatus.BAD_REQUEST,
    public readonly details?: unknown,
  ) {
    super({ code, message, details }, status);
  }
}
