export default () => ({
  nodeEnv: process.env.NODE_ENV ?? "development",
  port: parseInt(process.env.PORT ?? "3000", 10),
  globalPrefix: process.env.GLOBAL_PREFIX ?? "api",
  apiVersion: process.env.API_VERSION ?? "1",
  corsOrigins: (process.env.CORS_ORIGINS ?? "").split(",").filter(Boolean),

  mongo: {
    uri: process.env.MONGO_URI!,
  },

  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET!,
    accessTtl: process.env.JWT_ACCESS_TTL ?? "900",
    refreshSecret: process.env.JWT_REFRESH_SECRET!,
    refreshTtl: process.env.JWT_REFRESH_TTL ?? "1209600",
  },
});
