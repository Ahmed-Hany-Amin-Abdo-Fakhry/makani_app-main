import {
  query,
  where,
  getDocs,
  doc,
  updateDoc,
  type DocumentSnapshot,
} from 'firebase/firestore';
import { usersCol } from '../firebase/collections';
import type { TeamRepository } from '@/domain/repositories/team-repository';
import type { AdminUser } from '@/domain/entities/admin-user';

function toAdminUser(snap: DocumentSnapshot): AdminUser {
  const d = snap.data() ?? {};
  return {
    uid: snap.id,
    email: (d['email'] as string) ?? '',
    fullName: (d['fullName'] as string) ?? '',
    isAdmin: (d['isAdmin'] as boolean) ?? false,
    provider: (d['provider'] as string) ?? 'password',
    photoBase64: d['photoBase64'] as string | undefined,
  };
}

export class FirebaseTeamRepository implements TeamRepository {
  async listAdmins(): Promise<AdminUser[]> {
    const q = query(usersCol, where('isAdmin', '==', true));
    const snap = await getDocs(q);
    return snap.docs.map(toAdminUser);
  }

  async findByEmail(email: string): Promise<AdminUser | null> {
    const q = query(usersCol, where('email', '==', email.trim().toLowerCase()));
    const snap = await getDocs(q);
    if (snap.empty) return null;
    return toAdminUser(snap.docs[0]!);
  }

  async setAdminRole(uid: string, isAdmin: boolean): Promise<void> {
    await updateDoc(doc(usersCol, uid), { isAdmin });
  }
}
