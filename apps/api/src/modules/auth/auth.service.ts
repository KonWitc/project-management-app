import { ForbiddenException, Injectable, UnauthorizedException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import * as argon2 from "argon2";
import { UsersService } from "../../users/users.service";
import { ConfigService } from "@nestjs/config";
import type { JwtSignOptions } from "@nestjs/jwt";

type ExpiresLike = NonNullable<JwtSignOptions["expiresIn"]>;

export interface Tokens {
  accessToken: string;
  refreshToken: string;
}
export interface AccessOnly {
  accessToken: string;
}

function parseExpires(input: string | undefined, fallback: ExpiresLike): ExpiresLike {
  if (!input) return fallback;
  const v = input.trim();

  if (/^\d+$/.test(v)) return Number(v) as ExpiresLike;

  if (/^\d+\s*[smhd]$/i.test(v)) return v.replace(/\s+/g, "") as ExpiresLike;

  throw new Error(
    "Invalid JWT expires format. Use seconds (e.g. 900) or smhd (e.g. 15m, 12h, 7d).",
  );
}

@Injectable()
export class AuthService {
  constructor(
    private readonly jwt: JwtService,
    private readonly users: UsersService,
    private readonly config: ConfigService,
  ) {}

  //? getters
  private get accessExp(): ExpiresLike {
    return parseExpires(this.config.get<string>("ACCESS_EXPIRES"), "15m");
  }
  private get refreshExp(): ExpiresLike {
    return parseExpires(this.config.get<string>("REFRESH_EXPIRES"), "14d");
  }
  private get accessSecret(): string {
    return this.config.getOrThrow<string>("JWT_ACCESS_SECRET");
  }
  private get refreshSecret(): string {
    return this.config.getOrThrow<string>("JWT_REFRESH_SECRET");
  }

  //? ====== PUBLIC API ========

  async signUp(dto: { email: string; password: string }) {
    const hash = await argon2.hash(dto.password);
    const user = await this.users.create({
      email: dto.email,
      passwordHash: hash,
    });
    return this.issueTokensAndPersist(user._id.toString());
  }

  async signIn(dto: { email: string; password: string }) {
    const user = await this.users.findByEmail(dto.email);
    if (!user) throw new UnauthorizedException("Invalid credentials");

    const { passwordHash } = user;
    if (!passwordHash) {
      throw new UnauthorizedException("Invalid credentials");
    }

    const ok = await argon2.verify(passwordHash, dto.password);
    if (!ok) throw new UnauthorizedException("Invalid credentials");

    return this.issueTokensAndPersist(user._id.toString());
  }

  private async issueTokensAndPersist(userId: string) {
    const accessToken = await this.jwt.signAsync(
      { sub: userId },
      { secret: this.accessSecret, expiresIn: this.accessExp },
    );

    const refreshToken = await this.jwt.signAsync(
      { sub: userId },
      { secret: this.refreshSecret, expiresIn: this.refreshExp },
    );
    const refreshHash = await argon2.hash(refreshToken);
    await this.users.setRefreshHash(userId, refreshHash);

    return { accessToken, refreshToken };
  }

  async refresh(userId: string, refreshToken: string) {
    const user = await this.users.findById(userId);
    if (!user?.refreshTokenHash) throw new ForbiddenException("Invalid refresh token");
    const ok = await argon2.verify(user.refreshTokenHash, refreshToken);
    if (!ok) throw new ForbiddenException("Invalid refresh token");
    return this.issueTokensAndPersist(userId);
  }

  async logout(userId: string) {
    await this.users.setRefreshHash(userId, undefined);
  }
}
