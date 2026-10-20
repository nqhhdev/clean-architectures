import '@testing-library/jest-dom/vitest';
import { configure } from '@testing-library/react';

// Async timeout of the test harness (ADR 0017).
configure({ asyncUtilTimeout: 3000 });

// jsdom does not implement scrolling; the router calls it on navigation.
if (typeof window !== 'undefined') window.scrollTo = () => undefined;
