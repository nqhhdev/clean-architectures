Naming, placement, error codes, logging and style rules.

# Concepts
* [Convention Template](_template-convention.md) - Copy this when recording a naming, placement or style rule.
* [Dart Style](dart-style.md) - Formatting, lints and language idioms used in the starter.
* [Error Codes](error-codes.md) - AppError codes are Feature.Reason; common ones in utils/common_errors, feature ones in domain/errors, each localized.
* [Logging](logging.md) - Log levels and their use through the Logger port; error is reserved for unrecoverable faults in the data layer.
* [Naming and Placement](naming.md) - Where every kind of file lives and what it is called - one table, one row per kind.
* [Route Conventions](route-conventions.md) - Paths are constants on AppRoutes, kebab-case; screens navigate with context.go, never a string literal.
* [Visibility](visibility.md) - Dart has library-private names only; implementation classes are kept out of the UI by the import rule, not by access modifiers.
