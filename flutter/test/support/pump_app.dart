import 'package:clean_architecture/app.dart';
import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// A bare screen with theme and localizations, for widget tests that do not
/// need the router.
Widget testScreen(
  Widget screen, {
  List<Override> overrides = const [],
  Brightness brightness = Brightness.light,
}) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: screen,
  ),
);

/// The full app (router, theme, l10n) with the given overrides.
Widget testApp({List<Override> overrides = const []}) =>
    ProviderScope(overrides: overrides, child: const App());
