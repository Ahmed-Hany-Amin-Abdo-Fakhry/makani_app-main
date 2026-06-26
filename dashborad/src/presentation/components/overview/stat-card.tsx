interface StatCardProps {
  label: string;
  value: number;
  loading?: boolean;
}

export function StatCard({ label, value, loading }: StatCardProps) {
  return (
    <div className="rounded-lg border bg-card p-6 shadow-sm">
      <p className="text-sm font-medium text-muted-foreground">{label}</p>
      {loading ? (
        <div className="mt-2 h-8 w-24 animate-pulse rounded bg-muted" />
      ) : (
        <p className="mt-2 text-3xl font-bold tracking-tight">{value.toLocaleString()}</p>
      )}
    </div>
  );
}
