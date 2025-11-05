import { CanActivate, ExecutionContext, Injectable, ForbiddenException } from '@nestjs/common';
import { ROLES_KEY } from '../decorators/roles.decorator';
import { Reflector } from '@nestjs/core';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}
  canActivate(ctx: ExecutionContext): boolean {
    const required = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      ctx.getHandler(),
      ctx.getClass(),
    ]);
    if (!required || required.length === 0) return true;
    const req = ctx.switchToHttp().getRequest<{ user?: { roles?: string[] } }>();
    const roles = req.user?.roles ?? [];
    const ok = required.every((r) => roles.includes(r));
    if (!ok) throw new ForbiddenException('Insufficient role');
    return true;
  }
}

//Użycie:
//@UseGuards(JwtAccessGuard, RolesGuard)
//@Roles('admin')
//@Get(...) ...
