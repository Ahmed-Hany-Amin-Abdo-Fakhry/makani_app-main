import type { AuthRepository } from '../../repositories/auth-repository';
import type { AdminUser } from '../../entities/admin-user';

export async function signInEmail(
  repo: AuthRepository,
  email: string,
  password: string
): Promise<AdminUser> {
  return repo.signInWithEmail(email, password);
}
