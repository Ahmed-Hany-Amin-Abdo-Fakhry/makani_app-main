import type { AuthRepository } from '../../repositories/auth-repository';
import type { AdminUser } from '../../entities/admin-user';

export async function signInGoogle(repo: AuthRepository): Promise<AdminUser> {
  return repo.signInWithGoogle();
}
