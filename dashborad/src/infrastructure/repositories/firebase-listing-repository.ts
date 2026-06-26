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
import { listingsCol } from '../firebase/collections';
import type { ListingRepository, ListingPage } from '@/domain/repositories/listing-repository';
import type { Listing, ListingStatus } from '@/domain/entities/listing';

function toListing(snap: DocumentSnapshot): Listing {
  const d = snap.data() ?? {};
  return {
    id: snap.id,
    ownerId: (d['ownerId'] as string) ?? '',
    propertyTypeKey: (d['propertyTypeKey'] as string) ?? '',
    genderPreferenceKey: (d['genderPreferenceKey'] as string) ?? '',
    governorate: d['governorate'] as string | undefined,
    district: d['district'] as string | undefined,
    addressLine: d['addressLine'] as string | undefined,
    monthlyRent: d['monthlyRent'] as number | undefined,
    totalBeds: d['totalBeds'] as number | undefined,
    status: (d['status'] as ListingStatus) ?? undefined,
    createdAt: d['createdAt']?.toDate?.() as Date | undefined,
    imageUrls: (d['imageUrls'] as string[]) ?? [],
  };
}

export class FirebaseListingRepository implements ListingRepository {
  async getPaginated(cursor: unknown | null, pageSize: number): Promise<ListingPage> {
    const constraints = cursor
      ? [orderBy('createdAt', 'desc'), startAfter(cursor), limit(pageSize)]
      : [orderBy('createdAt', 'desc'), limit(pageSize)];

    const q = query(listingsCol, ...constraints);
    const snap = await getDocs(q);
    const listings = snap.docs.map(toListing);
    const nextCursor = snap.docs.length === pageSize ? snap.docs[snap.docs.length - 1] : null;
    return { listings, nextCursor };
  }

  async updateStatus(listingId: string, status: ListingStatus): Promise<void> {
    await updateDoc(doc(listingsCol, listingId), {
      status,
      updatedAt: serverTimestamp(),
    });
  }
}
