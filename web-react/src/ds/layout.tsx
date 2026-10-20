import type { ElementType, ReactNode } from 'react';

import styles from './layout.module.css';

export type Gap = 1 | 2 | 3 | 4;

const gapClass: Record<Gap, string | undefined> = {
  1: styles.gap1,
  2: styles.gap2,
  3: styles.gap3,
  4: styles.gap4,
};

interface FlowProps {
  children: ReactNode;
  /** Spacing step: maps to `--space-<gap>`. */
  gap?: Gap;
  /** Element to render; use `ul` or `nav` where the semantics fit. */
  as?: ElementType;
}

/** Centred, width-limited content area of a screen. */
export function Page({ children }: { children: ReactNode }) {
  return <main className={styles.page}>{children}</main>;
}

/** Vertical flow. */
export function Stack({ children, gap = 3, as: Tag = 'div' }: FlowProps) {
  return <Tag className={[styles.stack, gapClass[gap]].join(' ')}>{children}</Tag>;
}

/** Horizontal flow. */
export function Inline({ children, gap = 3, as: Tag = 'div' }: FlowProps) {
  return <Tag className={[styles.inline, gapClass[gap]].join(' ')}>{children}</Tag>;
}
