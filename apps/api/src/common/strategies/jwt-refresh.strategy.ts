import * as common from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import { Strategy, type StrategyOptionsWithRequest } from "passport-jwt";
import { ConfigService } from "@nestjs/config";
import { RefreshAuthUser } from "../auth.types";

function getRefreshFromReq(req: Request): string | undefined {
  const cookies: unknown = (req as Request & { cookies?: unknown }).cookies;

  if (typeof cookies === "object" && cookies !== null) {
    const val = (cookies as Record<string, unknown>)["refresh_token"];
    if (typeof val === "string") return val;
  }
  return undefined;
}
@common.Injectable()
export class JwtRefreshStrategy extends PassportStrategy(Strategy, "jwt-refresh") {
  constructor(private readonly config: ConfigService) {
    const opts: StrategyOptionsWithRequest = {
      jwtFromRequest: (req: Request) => getRefreshFromReq(req) ?? null,
      secretOrKey: config.getOrThrow<string>("JWT_REFRESH_SECRET"),
      passReqToCallback: true,
    };
    super(opts);
  }

  validate(req: Request, payload: { sub: string }): RefreshAuthUser {
    return { userId: payload.sub, refreshToken: getRefreshFromReq(req) };
  }
}
