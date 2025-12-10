import { ExecutionContext, Injectable, UnauthorizedException } from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import type { Request } from "express";
import type { AuthUser } from "../auth.types";

function isAuthUser(x: unknown): x is AuthUser {
  return (
    typeof x === "object" && x !== null && typeof (x as { userId?: unknown }).userId === "string"
  );
}

@Injectable()
export class JwtAccessGuard extends AuthGuard("jwt") {
  handleRequest<TUser = AuthUser>(
    err: Error,
    user: unknown,
    _info: unknown,
    context: ExecutionContext,
  ): TUser {
    if (err) throw err;

    if (!isAuthUser(user)) {
      const req = context.switchToHttp().getRequest<Request>();
      const hasAuth = typeof req.headers["authorization"] === "string";
      throw new UnauthorizedException(
        hasAuth ? "Invalid or expired access token" : "Missing access token",
      );
    }
    return user as unknown as TUser;
  }
}
