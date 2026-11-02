How to write one more of something. One page per pattern the repo actually uses; copy the template.

# Choose a pattern

The starter mandates none of these. Pick per row, record the choice as an [ADR](../../adr/index.md), then add a pattern page.
Options are listed alphabetically, not ranked.

| Concern | Common options |
|---|---|
| Server state / data fetching | plain `fetch` in loaders, RTK Query, SWR, TanStack Query, framework loaders |
| Client state | Context + `useReducer`, Jotai, MobX, Redux Toolkit, Zustand |
| Routing | framework file routing, React Router, TanStack Router |
| Validation at the boundary | ArkType, generated types from OpenAPI / GraphQL, Valibot, Yup, Zod |
| Forms | Formik, native forms + actions, React Hook Form, TanStack Form |
| Expected failures | thrown errors with typed classes, a `Result` type |
| Styling | CSS Modules, CSS-in-JS, plain CSS with variables, Tailwind, a component library |
| i18n | FormatJS / react-intl, i18next, Lingui |
| Test doubles and API mocking | fakes, MSW, test-runner mocks |
| Project structure | layer-first folders, feature-first folders, packages per feature |

# Concepts
* [Pattern Template](_template-pattern.md) - Copy this when documenting how to write one more of something.
