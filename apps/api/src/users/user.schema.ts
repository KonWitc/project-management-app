import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes, Types } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

export enum UserStatus {
  ACTIVE = 'active',
  PENDING = 'pending',
  DISABLED = 'disabled',
  BANNED = 'banned',
}

export enum AppRole {
  USER = 'user',
  MANAGER = 'manager',
  ADMIN = 'admin',
}

@Schema({ _id: false })
class NotificationPrefs {
  @Prop({ default: true }) declare emailSecurity?: boolean;
  @Prop({ default: true }) declare inApp?: boolean;
}
export const NotificationPrefsSchema = SchemaFactory.createForClass(NotificationPrefs);

@Schema({ _id: false })
class Preferences {
  @Prop({ default: 'system' }) declare theme?: 'light' | 'dark' | 'system';
  @Prop({ default: 'pl-PL' }) declare locale?: string;
  @Prop({ default: 'Europe/Warsaw' }) declare timeZone?: string;
  @Prop({ type: NotificationPrefsSchema, default: () => ({}) })
  declare notifications?: NotificationPrefs;
}
export const PreferencesSchema = SchemaFactory.createForClass(Preferences);

@Schema({ _id: false })
class Profile {
  @Prop({ unique: true, sparse: true, lowercase: true, trim: true })
  declare username?: string;
  @Prop({ trim: true }) declare displayName?: string;
  @Prop() declare photoUrl?: string;
  @Prop() declare phone?: string;
  @Prop() declare jobTitle?: string;
  @Prop({ type: [String], default: [] }) declare tags?: string[];
}
export const ProfileSchema = SchemaFactory.createForClass(Profile);

@Schema({ timestamps: true })
export class User {
  @Prop({ unique: true, lowercase: true, index: true, required: true })
  declare email: string;

  @Prop({ select: false, required: true })
  declare passwordHash: string;

  @Prop({ select: false })
  declare refreshTokenHash?: string;

  @Prop({ default: false })
  declare emailVerified: boolean;

  // --- Status and RBAC ---
  @Prop({ enum: UserStatus, default: UserStatus.ACTIVE })
  declare status: UserStatus;

  @Prop({ type: [String], enum: Object.values(AppRole), default: [AppRole.USER] })
  declare roles: AppRole[]; // multi role (np. USER + MANAGER)

  @Prop({ type: [String], default: [] })
  declare permissions: string[];

  // --- Organization / relations ---
  @Prop({ type: SchemaTypes.ObjectId, ref: 'Organization' })
  declare organizationId?: Types.ObjectId;

  @Prop({ type: [SchemaTypes.ObjectId], ref: 'Team', default: [] })
  declare teamIds?: Types.ObjectId[];

  // --- Profile and preferences ---
  @Prop({ type: ProfileSchema, default: () => ({}) })
  declare profile: Profile;

  @Prop({ type: PreferencesSchema, default: () => ({}) })
  declare preferences: Preferences;

  // --- Security and audit ---
  @Prop({ default: false }) declare mfaEnabled: boolean;
  @Prop() declare lastLoginAt?: Date;
  @Prop() declare lastLoginIp?: string;
  @Prop({ default: 0 }) declare failedLoginCount: number;
  @Prop() declare passwordChangedAt?: Date;

  // --- Soft delete ---
  @Prop({ index: true, default: null })
  declare deletedAt?: Date;
}

export const UserSchema = SchemaFactory.createForClass(User);

// --- Indexes and hooks ---
UserSchema.index(
  { 'profile.username': 1 },
  { unique: true, sparse: true }, // unique only if username set
);
UserSchema.index({ email: 1 }, { unique: true });
UserSchema.index({ status: 1, roles: 1 });
UserSchema.index({ 'profile.displayName': 'text', email: 'text' }); // search
UserSchema.index({ organizationId: 1, 'profile.username': 1 });
UserSchema.index({ deletedAt: 1 }); // active users filter

// hide in toJSON
UserSchema.set('toJSON', {
  virtuals: true,
  versionKey: false,
  transform: (_doc, ret) => {
    const r = ret as unknown as {
      _id?: Types.ObjectId | string;
      id?: string;
      passwordHash?: unknown;
      refreshTokenHash?: unknown;
      [k: string]: unknown;
    };

    // set id as string
    const oid = r._id;
    const toStr = typeof oid === 'string' ? oid : oid?.toHexString?.();
    r.id = toStr ?? String(oid);

    // remove technical fields
    delete r._id;
    delete r.passwordHash;
    delete r.refreshTokenHash;

    return r;
  },
});
