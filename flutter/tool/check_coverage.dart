import 'dart:io';

/// Fails when line coverage in coverage/lcov.info is below a threshold.
///
///   flutter test --coverage
///   dart run tool/check_coverage.dart 70
///
/// Generated code is excluded: it is not ours to test.
void main(List<String> args) {
  final threshold = args.isEmpty ? 70.0 : double.parse(args.first);
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    stderr.writeln('coverage/lcov.info not found; run flutter test --coverage');
    exit(2);
  }

  var found = 0;
  var hit = 0;
  var include = false;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3);
      include =
          !path.endsWith('.g.dart') &&
          !path.endsWith('.freezed.dart') &&
          !path.contains('/generated/');
    } else if (include && line.startsWith('LF:')) {
      found += int.parse(line.substring(3));
    } else if (include && line.startsWith('LH:')) {
      hit += int.parse(line.substring(3));
    }
  }

  final percent = found == 0 ? 0.0 : hit * 100 / found;
  stdout.writeln(
    'line coverage: ${percent.toStringAsFixed(1)}% ($hit/$found), '
    'threshold $threshold%',
  );
  if (percent < threshold) exit(1);
}
