import {
  query,
  orderBy,
  limit,
  startAfter,
  getDocs,
  doc,
  updateDoc,
  serverTimestamp,
  type DocumentSnapshot,
} from 'firebase/firestore';
import { listingReportsCol } from '../firebase/collections';
import type { ReportRepository, ReportPage } from '@/domain/repositories/report-repository';
import type { Report, ReportStatus } from '@/domain/entities/report';

function toReport(snap: DocumentSnapshot): Report {
  const d = snap.data() ?? {};
  return {
    id: snap.id,
    listingId: (d['listingId'] as string) ?? '',
    reporterUid: (d['reporterUid'] as string) ?? '',
    ownerId: (d['ownerId'] as string) ?? '',
    reason: (d['reason'] as string) ?? '',
    status: (d['status'] as ReportStatus) ?? 'pending',
    createdAt: d['createdAt']?.toDate?.() as Date | undefined,
    updatedAt: d['updatedAt']?.toDate?.() as Date | undefined,
  };
}

export class FirebaseReportRepository implements ReportRepository {
  async getPaginated(cursor: unknown | null, pageSize: number): Promise<ReportPage> {
    const constraints = cursor
      ? [orderBy('createdAt', 'desc'), startAfter(cursor), limit(pageSize)]
      : [orderBy('createdAt', 'desc'), limit(pageSize)];

    const q = query(listingReportsCol, ...constraints);
    const snap = await getDocs(q);
    const reports = snap.docs.map(toReport);
    const nextCursor = snap.docs.length === pageSize ? snap.docs[snap.docs.length - 1] : null;
    return { reports, nextCursor };
  }

  async markReviewed(reportId: string): Promise<void> {
    await updateDoc(doc(listingReportsCol, reportId), {
      status: 'reviewed',
      updatedAt: serverTimestamp(),
    });
  }
}
