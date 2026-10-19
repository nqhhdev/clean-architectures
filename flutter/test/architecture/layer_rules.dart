import 'package:path/path.dart' as p;

/// Pure rule checkers. They work on file contents (no IO) so the rules
/// themselves can be tested against deliberately bad sources
/// (see layers_test.dart).
///
/// Layers follow the Flutter app-architecture guide (UI / Data / optional
/// Domain), with `config` as the dependency-injection seam and
/// `domain/use_cases` as the optional use-case layer (ADR 0010).
const allowedImports = <String, Set<String>>{
  'utils': {},
  'domain': {'utils'},
  'data/services': {'domain', 'utils'},
  'data/repositories': {'domain', 'utils', 'data/services'},
  'domain/use_cases': {'domain', 'utils', 'data/repositories'},
  'config': {
    'domain',
    'domain/use_cases',
    'utils',
    'data/services',
    'data/repositories',
  },
  'ui': {
    'domain',
    'domain/use_cases',
    'utils',
    'data/repositories',
    'config',
  },
};

/// Flutter imports a restricted layer may still use. Any other
/// `package:flutter*` import (material, widgets, riverpod bindings,
/// localizations, ...) is a violation. Layers absent from this map (`ui`,
/// `config`) may use Flutter freely.
const flutterAllowlist = <String, Set<String>>{
  'utils': {},
  'domain': {},
  'domain/use_cases': {},
  'data/services': {
    'package:flutter/services.dart',
    'package:flutter/foundation.dart',
  },
  'data/repositories': {'package:flutter/foundation.dart'},
};

/// Also banned in every restricted layer: state management, routing and
/// `dart:ui` belong to ui/config.
const bannedInRestrictedLayers = [
  'package:riverpod',
  'package:go_router',
  'dart:ui',
];

/// Concrete repository implementations; only DI (config) and root files may
/// import them.
final _implementation = RegExp(r'_(local|remote)\.dart$');

/// Files directly under lib/ (main.dart, app.dart) are the composition root
/// and may see everything.
const root = '_root';

final _importPattern = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

/// Generated code is not subject to the rules.
bool isGenerated(String libRelativePath) =>
    libRelativePath.endsWith('.g.dart') ||
    libRelativePath.endsWith('.freezed.dart') ||
    libRelativePath.contains('/generated/');

String? layerOf(String libRelativePath) {
  if (!libRelativePath.contains('/')) return root;
  // Longest prefix first so `domain/use_cases` wins over `domain`.
  final byLength = allowedImports.keys.toList()
    ..sort((a, b) => b.length - a.length);
  for (final layer in byLength) {
    if (libRelativePath.startsWith('$layer/')) return layer;
  }
  return null;
}

String? _repositoryFeature(String path) {
  const prefix = 'data/repositories/';
  if (!path.startsWith(prefix)) return null;
  final rest = path.substring(prefix.length);
  return rest.contains('/') ? rest.split('/').first : null;
}

/// [sources] maps a path relative to lib/ (for example
/// `domain/models/email.dart`) to its content.
List<String> findViolations(
  Map<String, String> sources, {
  String package = 'clean_architecture',
}) {
  final violations = <String>[];
  for (final MapEntry(key: path, value: content) in sources.entries) {
    if (isGenerated(path)) continue;
    final from = layerOf(path);
    if (from == null) {
      violations.add(
        '$path: not inside a known layer (${allowedImports.keys.join(', ')})',
      );
      continue;
    }
    for (final match in _importPattern.allMatches(content)) {
      final uri = match.group(1)!;
      violations.addAll(_externalViolations(path, from, uri));

      final target = _resolve(path, uri, package);
      if (target == null) continue;
      final to = layerOf(target);
      if (to == null) continue;

      if (_implementation.hasMatch(target) &&
          from != 'config' &&
          from != root) {
        violations.add(
          '$path: only config/ and root files may import repository '
          'implementations ($uri)',
        );
      }
      if (from == root || to == root) continue;

      final a = _repositoryFeature(path);
      final b = _repositoryFeature(target);
      if (a != null && b != null && a != b) {
        violations.add(
          '$path: repositories must not depend on each other ($uri)',
        );
      }
      if (to == from) continue;
      if (!allowedImports[from]!.contains(to)) {
        violations.add('$path: layer "$from" must not depend on "$to" ($uri)');
      }
    }
  }
  return violations;
}

Iterable<String> _externalViolations(
  String path,
  String layer,
  String uri,
) sync* {
  final allowed = flutterAllowlist[layer];
  if (allowed == null) return; // ui, config, root: unrestricted
  if (uri.startsWith('package:flutter') && !allowed.contains(uri)) {
    yield '$path: layer "$layer" must not import Flutter ($uri)';
  }
  for (final banned in bannedInRestrictedLayers) {
    if (uri.startsWith(banned)) {
      yield '$path: layer "$layer" must not import $banned ($uri)';
    }
  }
}

String? _resolve(String fromPath, String uri, String package) {
  if (uri.startsWith('dart:')) return null;
  if (uri.startsWith('package:')) {
    final prefix = 'package:$package/';
    return uri.startsWith(prefix) ? uri.substring(prefix.length) : null;
  }
  final resolved = p.posix.normalize(
    p.posix.join(p.posix.dirname('lib/$fromPath'), uri),
  );
  return resolved.startsWith('lib/') ? resolved.substring(4) : null;
}

// ---------------------------------------------------------------- naming ---

final _classDeclaration = RegExp(
  r'^(?:(?:abstract|final|base|interface|sealed|mixin)\s+)*class\s+(\w+)',
  multiLine: true,
);

String _pascal(String snake) => snake
    .split('_')
    .where((part) => part.isNotEmpty)
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join();

/// (folder, file suffix, class suffix). A file `emails_view_model.dart` under
/// `ui/` must declare `EmailsViewModel`, and any class ending in `ViewModel`
/// must live in such a file.
const _namingRules = <(String, String, String)>[
  ('ui/', '_view_model.dart', 'ViewModel'),
  ('ui/', '_screen.dart', 'Screen'),
  ('data/repositories/', '_repository.dart', 'Repository'),
  ('data/repositories/', '_repository_remote.dart', 'RepositoryRemote'),
  ('data/repositories/', '_repository_local.dart', 'RepositoryLocal'),
  ('data/services/', '_service.dart', 'Service'),
  ('domain/use_cases/', '_use_case.dart', 'UseCase'),
];

/// Naming rules from the Naming and Placement convention, checked both ways.
List<String> findNamingViolations(Map<String, String> sources) {
  final violations = <String>[];
  for (final MapEntry(key: path, value: content) in sources.entries) {
    if (isGenerated(path)) continue;
    final classes = [
      for (final m in _classDeclaration.allMatches(content)) m.group(1)!,
    ];
    final file = p.posix.basename(path);

    for (final (folder, fileSuffix, _) in _namingRules) {
      if (path.startsWith(folder) && file.endsWith(fileSuffix)) {
        final expected = _pascal(file.substring(0, file.length - 5));
        if (!classes.contains(expected)) {
          violations.add('$path: must declare class $expected');
        }
      }
    }
    for (final name in classes) {
      for (final (folder, fileSuffix, classSuffix) in _namingRules) {
        final inRightFile =
            path.startsWith(folder) && file.endsWith(fileSuffix);
        if (name.endsWith(classSuffix) && !inRightFile) {
          violations.add(
            '$path: class $name ends with $classSuffix, so it belongs in a '
            '*$fileSuffix file under $folder',
          );
        }
      }
    }
  }
  return violations;
}

// ------------------------------------------------------------ style rules ---

/// `TextStyle(` outside `ui/core/theme/` (ADR 0016): styles come from the theme.
List<String> findInlineTextStyles(Map<String, String> sources) => [
  for (final MapEntry(key: path, value: content) in sources.entries)
    if (path.startsWith('ui/') &&
        !path.startsWith('ui/core/theme/') &&
        !isGenerated(path) &&
        RegExp(r'\bTextStyle\(').hasMatch(content))
      '$path: inline TextStyle; use the theme (ui/core/theme)',
];

final _buildSignature = RegExp(
  r'\bbuild\(\)\s*(async\s*)?(=>|\{)',
);

/// Stand-in for the `riverpod_lint` rule that cannot be installed on this
/// SDK (ADR 0014): inside a Notifier's `build()`, depend on providers with
/// `ref.watch`, never `ref.read`.
List<String> findRefReadInNotifierBuild(Map<String, String> sources) {
  final violations = <String>[];
  for (final MapEntry(key: path, value: content) in sources.entries) {
    if (isGenerated(path)) continue;
    if (!content.contains('Notifier<')) continue;
    for (final match in _buildSignature.allMatches(content)) {
      final body = match.group(2) == '=>'
          ? _untilSemicolon(content, match.end)
          : _braceBody(content, match.end - 1);
      if (body.contains('ref.read(')) {
        violations.add('$path: ref.read inside build(); use ref.watch');
      }
    }
  }
  return violations;
}

String _untilSemicolon(String text, int start) {
  final end = text.indexOf(';', start);
  return text.substring(start, end < 0 ? text.length : end);
}

String _braceBody(String text, int openIndex) {
  var depth = 0;
  for (var i = openIndex; i < text.length; i++) {
    if (text[i] == '{') depth++;
    if (text[i] == '}') {
      depth--;
      if (depth == 0) return text.substring(openIndex, i);
    }
  }
  return text.substring(openIndex);
}
