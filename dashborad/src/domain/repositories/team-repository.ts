import type { AdminUser } from '../entities/admin-user';

export interface TeamRepository {
  listAdmins(): Promise<AdminUser[]>;
  findByEmail(email: string): Promise<AdminUser | null>;
  setAdminRole(uid: string, isAdmin: boolean): Promise<void>;
}
