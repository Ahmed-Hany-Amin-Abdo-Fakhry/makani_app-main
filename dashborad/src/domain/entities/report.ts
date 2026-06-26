export type ReportStatus = 'pending' | 'reviewed';

export interface Report {
  id: string;
  listingId: string;
  reporterUid: string;
  ownerId: string;
  reason: string;
  status: ReportStatus;
  createdAt?: Date;
  updatedAt?: Date;
}
