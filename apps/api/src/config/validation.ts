import * as Joi from 'joi';

export const validationSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'test', 'production').default('development'),
  PORT: Joi.number().default(3000),
  GLOBAL_PREFIX: Joi.string().default('api'),
  API_VERSION: Joi.alternatives(Joi.string(), Joi.number()).default('1'),
  CORS_ORIGINS: Joi.string().allow(''),

  MONGODB_URI: Joi.string().uri().required(),

  JWT_ACCESS_SECRET: Joi.string().min(16).required(),
  JWT_ACCESS_TTL: Joi.alternatives(Joi.string(), Joi.number()).default('900'),
  JWT_REFRESH_SECRET: Joi.string().min(16).required(),
  JWT_REFRESH_TTL: Joi.alternatives(Joi.string(), Joi.number()).default('1209600'),
});
