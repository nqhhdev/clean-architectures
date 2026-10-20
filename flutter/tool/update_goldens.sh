#!/bin/sh
# Regenerate golden images on Linux, the platform CI renders them on (Linux/CI goldens are canonical).
# Usage, from flutter/:   tool/update_goldens.sh [test paths...]   (default: every test tagged golden)
# Needs Docker. Uses the Flutter version pinned in .github/workflows/flutter-ci.yml; the SDK is cached in a volume.
set -eu
cd "$(dirname "$0")/.."
version=$(sed -n 's/^ *flutter-version: *\([0-9.]*\).*/\1/p' ../.github/workflows/flutter-ci.yml)
[ -n "$version" ] || { echo "update_goldens: no flutter-version in flutter-ci.yml" >&2; exit 1; }
targets=${*:-test}
docker run --rm --platform linux/amd64 \
  -v "$PWD":/src:ro -v "$PWD/test":/out \
  -v "flutter-sdk-$version":/opt/flutter \
  ubuntu:24.04 bash -euc "
    apt-get update -qq >/dev/null && apt-get install -y -qq curl git xz-utils unzip ca-certificates rsync >/dev/null
    if [ ! -x /opt/flutter/bin/flutter ]; then
      curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz \
        | tar -xJ -C /opt
    fi
    git config --global --add safe.directory '*'
    export PATH=/opt/flutter/bin:\$PATH
    # Work on a copy, so the host's .dart_tool and build/ are not overwritten with Linux paths.
    rsync -a --exclude .dart_tool --exclude build /src/ /work/
    cd /work
    flutter pub get >/dev/null
    dart run build_runner build -d >/dev/null
    flutter test --update-goldens --tags golden $targets
    find test -path '*/goldens/*.png' -exec sh -c 'mkdir -p /out/\$(dirname \${1#test/}) && cp \"\$1\" /out/\${1#test/}' _ {} \;
  "
echo "update_goldens: done; review the changed images with git diff --stat"
