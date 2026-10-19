import 'package:clean_architecture/ui/core/theme/app_colors.dart';
import 'package:clean_architecture/ui/core/theme/app_text_styles.dart';
import 'package:clean_architecture/ui/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light and dark themes carry the extensions; unread is bolder', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      final styles = theme.extension<AppTextStyles>()!;
      expect(theme.extension<AppColors>(), isNotNull);
      expect(
        styles.unreadTitle.fontWeight!.value,
        greaterThan(styles.readTitle.fontWeight!.value),
      );
    }
    expect(
      AppTheme.light().colorScheme.surface,
      isNot(AppTheme.dark().colorScheme.surface),
    );
  });
}
