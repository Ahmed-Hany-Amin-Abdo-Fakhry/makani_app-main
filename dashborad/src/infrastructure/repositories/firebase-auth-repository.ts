import {
  signInWithEmailAndPassword,
  signInWithRedirect,
  GoogleAuthProvider,
  signOut as firebaseSignOut,
  onAuthStateChanged as firebaseOnAuthStateChanged,
  type User,
} from 'firebase/auth';
import { doc, getDoc } from 'firebase/firestore';
import { auth, db } from '../firebase/app';
import type { AuthRepository } from '@/domain/repositories/auth-repository';
import type { AdminUser } from '@/domain/entities/admin-user';

export class AccessDeniedError extends Error {
  constructor() {
    super('Not an admin account');
    this.name = 'AccessDeniedError';
  }
}

async function toAdminUser(user: User): Promise<AdminUser> {
  const snap = await getDoc(doc(db, 'users', user.uid));
  const data = snap.data();
  if (!data?.['isAdmin']) throw new AccessDeniedError();
  return {
    uid: user.uid,
    email: user.email ?? '',
    fullName: (data['fullName'] as string) ?? '',
    isAdmin: true,
    provider: (data['provider'] as string) ?? 'password',
    photoBase64: data['photoBase64'] as string | undefined,
  };
}

export class FirebaseAuthRepository implements AuthRepository {
  async signInWithEmail(email: string, password: string): Promise<AdminUser> {
    const { user } = await signInWithEmailAndPassword(auth, email, password);
    return toAdminUser(user);
  }

  async signInWithGoogle(): Promise<void> {
    const provider = new GoogleAuthProvider();
    await signInWithRedirect(auth, provider);
  }

  async signOut(): Promise<void> {
    await firebaseSignOut(auth);
  }

  onAuthStateChanged(callback: (user: AdminUser | null) => void): () => void {
    return firebaseOnAuthStateChanged(auth, async (user) => {
      if (!user) {
        callback(null);
        return;
      }
      try {
        const adminUser = await toAdminUser(user);
        callback(adminUser);
      } catch {
        callback(null);
      }
    });
  }
}
