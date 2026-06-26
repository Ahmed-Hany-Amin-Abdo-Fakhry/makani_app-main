import { TopNav } from './top-nav';

export function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex flex-col">
      <TopNav />
      <main className="flex-1 container mx-auto max-w-7xl px-4 py-6">{children}</main>
    </div>
  );
}
