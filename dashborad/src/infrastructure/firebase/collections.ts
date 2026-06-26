import { collection, doc } from 'firebase/firestore';
import { db } from './app';

export const usersCol = collection(db, 'users');
export const listingsCol = collection(db, 'listings');
export const listingReportsCol = collection(db, 'listingReports');
export const statsDoc = doc(db, 'stats', 'overview');
