import 'package:flutter/material.dart';

/// Text styles that Material's [TextTheme] has no slot for. Widgets read them
/// with `Theme.of(context).extension<AppTextStyles>()!`; no widget builds a
/// `TextStyle` inline (enforced by an architecture test).
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({required this.unreadTitle, required this.readTitle});

  factory AppTextStyles.from(TextTheme base) => AppTextStyles(
    unreadTitle: base.titleMedium!.copyWith(fontWeight: FontWeight.w700),
    readTitle: base.titleMedium!.copyWith(fontWeight: FontWeight.w400),
  );

  final TextStyle unreadTitle;
  final TextStyle readTitle;

  @override
  AppTextStyles copyWith({TextStyle? unreadTitle, TextStyle? readTitle}) =>
      AppTextStyles(
        unreadTitle: unreadTitle ?? this.unreadTitle,
        readTitle: readTitle ?? this.readTitle,
      );

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      unreadTitle: TextStyle.lerp(unreadTitle, other.unreadTitle, t)!,
      readTitle: TextStyle.lerp(readTitle, other.readTitle, t)!,
    );
  }
}
