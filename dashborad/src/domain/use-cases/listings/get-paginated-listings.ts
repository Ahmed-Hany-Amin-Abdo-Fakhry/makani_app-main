import type { ListingRepository, ListingPage } from '../../repositories/listing-repository';

export async function getPaginatedListings(
  repo: ListingRepository,
  cursor: unknown | null,
  pageSize: number
): Promise<ListingPage> {
  return repo.getPaginated(cursor, pageSize);
}
