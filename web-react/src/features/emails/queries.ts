import { queryOptions } from '@tanstack/react-query';

import { QueryError } from '@/application/query-error';
import type { Services } from '@/application/services';

export const emailKeys = {
  all: ['emails'] as const,
  list: () => [...emailKeys.all, 'list'] as const,
};

/** Shared by the route loader and the screen, so prefetch and read cannot drift (ADR 0013). */
export function emailsQueryOptions({ emails }: Pick<Services, 'emails'>) {
  return queryOptions({
    queryKey: emailKeys.list(),
    // The one place a `Result` is unwrapped: TanStack Query needs a thrown error (ADR 0012).
    queryFn: async ({ signal }) => {
      const result = await emails.list(signal);
      if (!result.ok) throw new QueryError(result.error);
      return result.value;
    },
  });
}
