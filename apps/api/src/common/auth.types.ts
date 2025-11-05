export interface AuthUser {
  userId: string;
  roles?: string[];
}

export interface RefreshAuthUser {
  userId: string;
  refreshToken?: string;
}
