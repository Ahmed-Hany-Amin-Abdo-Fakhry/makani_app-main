export interface AdminUser {
  uid: string;
  fullName: string;
  email: string;
  isAdmin: boolean;
  provider: string;
  photoBase64?: string;
}

export function isAdminUser(value: unknown): value is AdminUser {
  if (typeof value !== 'object' || value === null) return false;
  const obj = value as Record<string, unknown>;
  return (
    typeof obj['uid'] === 'string' &&
    typeof obj['email'] === 'string' &&
    obj['isAdmin'] === true
  );
}
