'use client';

import { useState } from 'react';
import { useTranslations } from 'next-intl';
import { Button } from '@/components/ui/button';

interface AddAdminFormProps {
  onAdd: (email: string) => Promise<void>;
  isLoading: boolean;
  error: 'not_found' | 'already_admin' | 'error' | null;
  onClearError: () => void;
}

export function AddAdminForm({ onAdd, isLoading, error, onClearError }: AddAdminFormProps) {
  const t = useTranslations('team');
  const [email, setEmail] = useState('');

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!email.trim()) return;
    await onAdd(email.trim());
    if (!error) setEmail('');
  }

  const errorMessage =
    error === 'not_found'
      ? t('errorNotFound')
      : error === 'already_admin'
        ? t('errorAlreadyAdmin')
        : error
          ? t('errorGeneric')
          : null;

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-3 sm:flex-row sm:items-start">
      <div className="flex-1 space-y-1">
        <input
          type="email"
          value={email}
          onChange={(e) => {
            setEmail(e.target.value);
            onClearError();
          }}
          placeholder={t('emailPlaceholder')}
          required
          disabled={isLoading}
          className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50"
        />
        {errorMessage && (
          <p className="text-xs text-destructive">{errorMessage}</p>
        )}
      </div>
      <Button type="submit" disabled={isLoading} className="shrink-0">
        {isLoading ? t('adding') : t('addAdmin')}
      </Button>
    </form>
  );
}
