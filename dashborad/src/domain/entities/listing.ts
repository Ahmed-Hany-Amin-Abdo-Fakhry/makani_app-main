export type ListingStatus = 'active' | 'inactive';

export interface Listing {
  id: string;
  ownerId: string;
  propertyTypeKey: string;
  genderPreferenceKey: string;
  governorate?: string;
  district?: string;
  addressLine?: string;
  monthlyRent?: number;
  totalBeds?: number;
  status?: ListingStatus;
  createdAt?: Date;
  imageUrls: string[];
}
