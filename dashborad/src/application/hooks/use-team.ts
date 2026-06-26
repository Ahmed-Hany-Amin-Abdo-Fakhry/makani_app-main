'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useDI } from '../providers/di-provider';

export function useTeam() {
  const { teamRepo } = useDI();
  const queryClient = useQueryClient();

  const adminsQuery = useQuery({
    queryKey: ['team', 'admins'],
    queryFn: () => teamRepo.listAdmins(),
  });

  const [addError, setAddError] = useState<'not_found' | 'already_admin' | 'error' | null>(null);

  const addAdmin = useMutation({
    mutationFn: async (email: string) => {
      setAddError(null);
      const user = await teamRepo.findByEmail(email);
      if (!user) {
        setAddError('not_found');
        throw new Error('not_found');
      }
      if (user.isAdmin) {
        setAddError('already_admin');
        throw new Error('already_admin');
      }
      await teamRepo.setAdminRole(user.uid, true);
      return user;
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['team', 'admins'] });
    },
  });

  const removeAdmin = useMutation({
    mutationFn: (uid: string) => teamRepo.setAdminRole(uid, false),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['team', 'admins'] });
    },
  });

  return { adminsQuery, addAdmin, addError, setAddError, removeAdmin };
}
