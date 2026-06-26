'use client';

import { useRef } from 'react';
import { toast } from 'sonner';
import { useTranslations } from 'next-intl';
import { Switch } from '@/components/ui/switch';
import { useUpdateListingStatus } from '@/application/hooks/use-listings';
import type { ListingStatus } from '@/domain/entities/listing';

interface StatusToggleProps {
  listingId: string;
  currentStatus: ListingStatus | undefined;
}

export function StatusToggle({ listingId, currentStatus }: StatusToggleProps) {
  const t = useTranslations('listings');
  const tCommon = useTranslations('common');
  const { mutate } = useUpdateListingStatus();
  const undoTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const isActive = currentStatus === 'active';

  function handleToggle(checked: boolean) {
    const next: ListingStatus = checked ? 'active' : 'inactive';
    const prev: ListingStatus = checked ? 'inactive' : 'active';

    mutate({ id: listingId, status: next });

    if (undoTimerRef.current) clearTimeout(undoTimerRef.current);

    toast(t('statusChanged'), {
      description: next === 'active' ? t('nowActive') : t('nowInactive'),
      action: {
        label: tCommon('undo'),
        onClick: () => {
          if (undoTimerRef.current) clearTimeout(undoTimerRef.current);
          mutate({ id: listingId, status: prev });
        },
      },
      duration: 5000,
    });
  }

  return (
    <Switch
      checked={isActive}
      onCheckedChange={handleToggle}
      aria-label={isActive ? t('deactivate') : t('activate')}
    />
  );
}
