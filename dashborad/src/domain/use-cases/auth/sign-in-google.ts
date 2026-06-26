import type { AuthRepository } from '../../repositories/auth-repository';
import type { AdminUser } from '../../entities/admin-user';

export async function signInGoogle(repo: AuthRepository): Promise<void> {
  return repo.signInWithGoogle();
}
