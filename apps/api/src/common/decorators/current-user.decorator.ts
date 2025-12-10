import { createParamDecorator, ExecutionContext } from "@nestjs/common";
import type { Request } from "express";
import { AuthUser } from "../auth.types";

export const CurrentUser = createParamDecorator((_: unknown, ctx: ExecutionContext): AuthUser => {
  const req = ctx.switchToHttp().getRequest<Request & { user?: unknown }>();
  const u = req.user as Partial<AuthUser> | undefined;
  if (!u || typeof u.userId !== "string") {
    return { userId: "" } as AuthUser;
  }
  return u as AuthUser;
});
