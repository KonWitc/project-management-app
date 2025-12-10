import { ExecutionContext, Injectable, UnauthorizedException } from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import type { Request } from "express";
import type { RefreshAuthUser } from "../auth.types";

function isRefreshAuthUser(x: unknown): x is RefreshAuthUser {
  return (
    typeof x === "object" && x !== null && typeof (x as { userId?: unknown }).userId === "string"
  );
}
function hasRefreshCookie(req: Request): boolean {
  const cookies: unknown = (req as Request & { cookies?: unknown }).cookies;
  return !!(
    cookies &&
    typeof cookies === "object" &&
    (cookies as Record<string, unknown>)["refresh_token"]
  );
}

@Injectable()
export class JwtRefreshGuard extends AuthGuard("jwt-refresh") {
  canActivate(ctx: ExecutionContext) {
    const req = ctx.switchToHttp().getRequest<Request>();
    if (!hasRefreshCookie(req)) throw new UnauthorizedException("Missing refresh cookie");
    return super.canActivate(ctx);
  }

  handleRequest<TUser = RefreshAuthUser>(err: Error, user: unknown): TUser {
    if (err) throw err;
    if (!isRefreshAuthUser(user)) {
      throw new UnauthorizedException("Invalid or expired refresh token");
    }
    return user as unknown as TUser;
  }
}
