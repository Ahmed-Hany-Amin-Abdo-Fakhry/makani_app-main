'use client';

import { useTranslations } from 'next-intl';
import { toast } from 'sonner';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { AddAdminForm } from './add-admin-form';
import { useTeam } from '@/application/hooks/use-team';
import { useAuthContext } from '@/application/providers/auth-provider';

export function AdminsTable() {
  const t = useTranslations('team');
  const tCommon = useTranslations('common');
  const { user: currentUser } = useAuthContext();
  const { adminsQuery, addAdmin, addError, setAddError, removeAdmin } = useTeam();

  const admins = adminsQuery.data ?? [];

  async function handleAdd(email: string) {
    await addAdmin.mutateAsync(email).then(() => {
      toast.success(t('adminAdded'));
    }).catch(() => {});
  }

  function handleRemove(uid: string, name: string) {
    removeAdmin.mutate(uid, {
      onSuccess: () => toast.success(t('adminRemoved', { name })),
    });
  }

  return (
    <div className="space-y-6">
      <div className="rounded-lg border bg-card p-4">
        <h2 className="mb-3 text-sm font-medium">{t('addAdminTitle')}</h2>
        <AddAdminForm
          onAdd={handleAdd}
          isLoading={addAdmin.isPending}
          error={addError}
          onClearError={() => setAddError(null)}
        />
      </div>

      <div className="rounded-lg border">
        {adminsQuery.isLoading ? (
          <div className="space-y-2 p-4">
            {Array.from({ length: 3 }).map((_, i) => (
              <div key={i} className="h-10 animate-pulse rounded bg-muted" />
            ))}
          </div>
        ) : admins.length === 0 ? (
          <div className="p-12 text-center text-sm text-muted-foreground">
            {tCommon('noData')}
          </div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{t('nameColumn')}</TableHead>
                <TableHead>{t('emailColumn')}</TableHead>
                <TableHead>{t('providerColumn')}</TableHead>
                <TableHead>{t('roleColumn')}</TableHead>
                <TableHead />
              </TableRow>
            </TableHeader>
            <TableBody>
              {admins.map((admin) => (
                <TableRow key={admin.uid}>
                  <TableCell className="font-medium">
                    {admin.fullName || '—'}
                  </TableCell>
                  <TableCell className="text-muted-foreground">{admin.email}</TableCell>
                  <TableCell>
                    <Badge variant="outline" className="capitalize">
                      {admin.provider}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <Badge>{t('roleAdmin')}</Badge>
                  </TableCell>
                  <TableCell className="text-end">
                    {currentUser?.uid !== admin.uid && (
                      <Button
                        size="sm"
                        variant="ghost"
                        className="text-destructive hover:text-destructive hover:bg-destructive/10"
                        disabled={removeAdmin.isPending}
                        onClick={() => handleRemove(admin.uid, admin.fullName || admin.email)}
                      >
                        {t('removeAdmin')}
                      </Button>
                    )}
                    {currentUser?.uid === admin.uid && (
                      <span className="text-xs text-muted-foreground">{t('you')}</span>
                    )}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </div>
    </div>
  );
}
