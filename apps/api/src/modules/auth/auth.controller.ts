import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Res,
  UnauthorizedException,
  UseGuards,
} from "@nestjs/common";
import type { Response } from "express";
import { AuthService } from "./auth.service";
import { SignInDto } from "./dto/signin.dto";
import { SignUpDto } from "./dto/signup.dto";
import { CurrentUser } from "@/common/decorators/current-user.decorator";
import { JwtRefreshGuard } from "@/common/guards/jwt-refresh.guard";
import { JwtAccessGuard } from "@/common/guards/jwt-access.guard";
import { CurrentRefreshUser } from "@/common/decorators/current-refresh-user.decorator";
import { AuthUser, RefreshAuthUser } from "@/common/auth.types";

@Controller("auth")
export class AuthController {
  constructor(private auth: AuthService) {}

  private cookieOpts() {
    const maxAgeDays = parseInt((process.env.REFRESH_EXPIRES || "14d").replace(/\D/g, "")) || 14;
    return {
      httpOnly: true,
      secure: true,
      sameSite: "lax" as const,
      maxAge: maxAgeDays * 24 * 3600 * 1000,
      domain: process.env.COOKIE_DOMAIN || undefined,
      path: "/",
    };
  }

  @Post("signup")
  async signUp(@Body() dto: SignUpDto, @Res({ passthrough: true }) res: Response) {
    const { accessToken, refreshToken } = await this.auth.signUp(dto);
    res.cookie("refresh_token", refreshToken, this.cookieOpts());
    return { accessToken };
  }

  @Post("signin")
  async signIn(@Body() dto: SignInDto, @Res({ passthrough: true }) res: Response) {
    console.log("auth controller");
    const { accessToken, refreshToken } = await this.auth.signIn(dto);
    res.cookie("refresh_token", refreshToken, this.cookieOpts());
    return { accessToken };
  }

  @UseGuards(JwtAccessGuard)
  @Get("me")
  me(@CurrentUser() user: AuthUser) {
    return { userId: user.userId };
  }

  @UseGuards(JwtRefreshGuard)
  @Post("refresh")
  async refresh(
    @CurrentRefreshUser() user: RefreshAuthUser,
    @Res({ passthrough: true }) res: Response,
  ) {
    if (!user.refreshToken) throw new UnauthorizedException("Missing refresh token");
    const { accessToken, refreshToken } = await this.auth.refresh(user.userId, user.refreshToken);
    res.cookie("refresh_token", refreshToken, this.cookieOpts());
    return { accessToken };
  }

  @Post("logout")
  @UseGuards(JwtAccessGuard)
  async logout(
    @Req() req: Request & { user: AuthUser },
    @Res({ passthrough: true }) res: Response,
  ) {
    await this.auth.logout(req.user.userId);
    res.clearCookie("refresh_token", { path: "/" });
    return { ok: true };
  }

  @Get("ping")
  ping() {
    return { ok: true, ts: Date.now() };
  }
}
