import type { AuthRepository } from '../../repositories/auth-repository';

export async function signOut(repo: AuthRepository): Promise<void> {
  return repo.signOut();
}
