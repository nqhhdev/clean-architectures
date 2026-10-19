import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Replaces the red error screen. In debug it keeps the framework's details;
/// in release it shows a neutral message and nothing technical.
///
/// Built with plain widgets on purpose: it can run outside any `Theme` or
/// `Localizations`, so it cannot use l10n or the app theme.
Widget buildErrorWidget(FlutterErrorDetails details) {
  if (!kReleaseMode) return ErrorWidget(details.exception);
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Something went wrong.',
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
