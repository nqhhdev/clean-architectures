import 'package:clean_architecture/ui/core/theme/app_colors.dart';
import 'package:clean_architecture/ui/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// The app theme: one seed color, light and dark [ColorScheme]s, a
/// [TextTheme], and the extensions in this folder.
abstract final class AppTheme {
  static const _seed = Color(0xFF2F6FED);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final textTheme = base.textTheme;
    return base.copyWith(
      extensions: [
        AppTextStyles.from(textTheme),
        AppColors(
          unreadAccent: scheme.primary,
          statusBanner: scheme.errorContainer,
        ),
      ],
    );
  }
}

/// Short accessors so widgets stay readable.
extension AppThemeContext on BuildContext {
  AppTextStyles get appText => Theme.of(this).extension<AppTextStyles>()!;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
