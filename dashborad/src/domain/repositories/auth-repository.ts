import type { AdminUser } from '../entities/admin-user';

export interface AuthRepository {
  signInWithEmail(email: string, password: string): Promise<AdminUser>;
  signInWithGoogle(): Promise<void>;
  signOut(): Promise<void>;
  onAuthStateChanged(callback: (user: AdminUser | null) => void): () => void;
}
