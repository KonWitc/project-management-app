import { Module } from "@nestjs/common";
import { JwtModule } from "@nestjs/jwt";
import { UsersModule } from "../../users/users.module";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { JwtAccessStrategy } from "../../common/strategies/jwt-access.strategy";
import { JwtRefreshStrategy } from "../../common/strategies/jwt-refresh.strategy";

@Module({
  imports: [JwtModule.register({}), UsersModule],
  providers: [AuthService, JwtAccessStrategy, JwtRefreshStrategy],
  controllers: [AuthController],
})
export class AuthModule {}
