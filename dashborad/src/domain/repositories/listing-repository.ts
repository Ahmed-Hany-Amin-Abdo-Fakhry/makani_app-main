import type { Listing, ListingStatus } from '../entities/listing';

export interface ListingPage {
  listings: Listing[];
  nextCursor: unknown | null;
}

export interface ListingRepository {
  getPaginated(cursor: unknown | null, pageSize: number): Promise<ListingPage>;
  updateStatus(listingId: string, status: ListingStatus): Promise<void>;
}
