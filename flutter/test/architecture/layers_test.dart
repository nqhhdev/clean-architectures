import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'layer_rules.dart';

Map<String, String> _readLib() => {
  for (final f in Directory('lib').listSync(recursive: true).whereType<File>())
    if (f.path.endsWith('.dart'))
      p.posix.joinAll(p.split(p.relative(f.path, from: 'lib'))): f
          .readAsStringSync(),
};

/// Read from pubspec so renaming the package cannot silently disable the
/// `package:<name>/...` import checks.
String _packageName() => RegExp(
  r'^name:\s*(\S+)',
  multiLine: true,
).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1)!;

void main() {
  const pkg = 'package:clean_architecture';
  final sources = _readLib();

  group('lib/ follows the rules', () {
    test('layer dependencies and Flutter bans', () {
      expect(sources, isNotEmpty);
      expect(findViolations(sources, package: _packageName()), isEmpty);
    });

    test('naming', () => expect(findNamingViolations(sources), isEmpty));

    test('no inline TextStyle outside the theme', () {
      expect(findInlineTextStyles(sources), isEmpty);
    });

    test('no ref.read inside a Notifier build()', () {
      expect(findRefReadInNotifierBuild(sources), isEmpty);
    });
  });

  // The checkers are tested on deliberately bad sources, so a green run above
  // means the rules work and are not vacuous.
  group('the checkers catch violations', () {
    List<String> check(Map<String, String> files) => findViolations(files);

    test('layer direction, including use cases', () {
      expect(
        check({
          'domain/models/a.dart': "import '$pkg/data/repositories/n/r.dart';",
        }).single,
        contains('must not depend on "data/repositories"'),
      );
      expect(
        check({
          'domain/use_cases/u.dart': "import '$pkg/data/services/s.dart';",
        }).single,
        contains('must not depend on "data/services"'),
      );
      expect(
        check({
          'domain/use_cases/u.dart':
              "import '$pkg/data/repositories/n/r.dart';",
          'ui/n/vm.dart': "import '$pkg/domain/use_cases/u.dart';",
        }),
        isEmpty,
      );
    });

    test('services, implementations and repository independence', () {
      expect(
        check({'ui/n/vm.dart': "import '$pkg/data/services/s.dart';"}),
        hasLength(1),
      );
      expect(
        check({
          'ui/n/vm.dart': "import '$pkg/data/repositories/n/r_remote.dart';",
        }).single,
        contains('implementations'),
      );
      expect(
        check({
          'data/repositories/a/r.dart':
              "import '$pkg/data/repositories/b/r.dart';",
        }).single,
        contains('must not depend on each other'),
      );
    });

    test('Flutter bans per layer', () {
      String? bad(String path, String uri) {
        final v = check({path: "import '$uri';"});
        return v.isEmpty ? null : v.single;
      }

      expect(
        bad('domain/models/a.dart', 'package:flutter/foundation.dart'),
        contains('Flutter'),
      );
      expect(
        bad('data/services/s.dart', 'package:flutter/material.dart'),
        contains('Flutter'),
      );
      expect(
        bad(
          'data/services/s.dart',
          'package:flutter_riverpod/flutter_riverpod.dart',
        ),
        contains('Flutter'),
      );
      expect(
        bad('data/services/s.dart', 'package:flutter/services.dart'),
        isNull,
      );
      expect(bad('ui/a.dart', 'package:flutter/material.dart'), isNull);
    });

    test('generated files and unknown folders', () {
      expect(
        check({
          'domain/a.freezed.dart': "import 'package:flutter/material.dart';",
        }),
        isEmpty,
      );
      expect(
        check({'misc/x.dart': ''}).single,
        contains('not inside a known layer'),
      );
    });

    test('naming, TextStyle and ref.read rules', () {
      expect(
        findNamingViolations({
          'ui/a/emails_view_model.dart': 'class Other {}',
        }).single,
        contains('must declare class EmailsViewModel'),
      );
      expect(
        findNamingViolations({'ui/a/helpers.dart': 'class FooViewModel {}'}),
        hasLength(1),
      );
      expect(
        findInlineTextStyles({'ui/emails/a.dart': 'TextStyle(fontSize: 3)'}),
        hasLength(1),
      );
      expect(
        findInlineTextStyles({
          'ui/core/theme/a.dart': 'TextStyle(fontSize: 3)',
        }),
        isEmpty,
      );
      expect(
        findRefReadInNotifierBuild({
          'ui/a.dart':
              'class A extends Notifier<int> {'
              ' int build() { return ref.read(p); } }',
        }),
        hasLength(1),
      );
    });
  });
}
