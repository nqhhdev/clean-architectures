import 'package:flutter/material.dart';

/// Semantic colors beyond [ColorScheme]. Light and dark values are chosen in
/// `AppTheme`; widgets never hard-code a `Color`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({required this.unreadAccent, required this.statusBanner});

  final Color unreadAccent;
  final Color statusBanner;

  @override
  AppColors copyWith({Color? unreadAccent, Color? statusBanner}) => AppColors(
    unreadAccent: unreadAccent ?? this.unreadAccent,
    statusBanner: statusBanner ?? this.statusBanner,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      unreadAccent: Color.lerp(unreadAccent, other.unreadAccent, t)!,
      statusBanner: Color.lerp(statusBanner, other.statusBanner, t)!,
    );
  }
}
