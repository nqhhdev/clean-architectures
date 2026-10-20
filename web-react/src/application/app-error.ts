export type AppErrorKind = 'refused' | 'unauthorized' | 'network' | 'invalid';

export interface AppError {
  kind: AppErrorKind;
  status?: number;
  code?: string;
}
