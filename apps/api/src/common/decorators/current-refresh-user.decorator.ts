import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';
import { RefreshAuthUser } from '../auth.types';

export const CurrentRefreshUser = createParamDecorator(
  (_: unknown, ctx: ExecutionContext): RefreshAuthUser => {
    const req = ctx.switchToHttp().getRequest<Request & { user?: unknown }>();
    return (req.user ?? {}) as RefreshAuthUser;
  },
);
