import { AdminGuard } from '@/presentation/guards/admin-guard';
import { AppShell } from '@/presentation/components/layout/app-shell';

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <AdminGuard>
      <AppShell>{children}</AppShell>
    </AdminGuard>
  );
}
