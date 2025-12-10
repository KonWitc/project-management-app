import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { ConfigModule } from "@nestjs/config";
import { AuthModule } from "./modules/auth/auth.module";
import { ProjectsModule } from "./modules/projects/projects.module";
import { UsersModule } from "./users/users.module";
import { RolesGuard } from "./common/guards/roles.guard";
import { APP_GUARD } from "@nestjs/core";
import { JwtModule } from "@nestjs/jwt";
import { validationSchema } from "./config/validation";
import configuration from "./config/configuration";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ["apps/api/.env", ".env"],
      validationSchema,
      load: [configuration],
    }),
    JwtModule.register({}),
    MongooseModule.forRoot(configuration().mongo.uri),
    UsersModule,
    AuthModule,
    ProjectsModule,
  ],
  providers: [{ provide: APP_GUARD, useClass: RolesGuard }],
})
export class AppModule {}
