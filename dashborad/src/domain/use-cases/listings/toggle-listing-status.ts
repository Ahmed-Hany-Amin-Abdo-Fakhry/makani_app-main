import type { ListingRepository } from '../../repositories/listing-repository';
import type { ListingStatus } from '../../entities/listing';

export async function toggleListingStatus(
  repo: ListingRepository,
  listingId: string,
  currentStatus: ListingStatus
): Promise<ListingStatus> {
  const next: ListingStatus = currentStatus === 'active' ? 'inactive' : 'active';
  await repo.updateStatus(listingId, next);
  return next;
}
