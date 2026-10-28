#!/usr/bin/env bash
# Builds upload-ready zips into dist/:
# - <skill>.zip, one skill folder each, for skill uploads (claude.ai,
#   ChatGPT Skills, Grok);
# - scc-skills.zip, the whole plugin with .codex-plugin/, .claude-plugin/
#   and skills/ at its root, for plugin uploads (ChatGPT's "New plugin").
#
#   scripts/build-zips.sh [VERSION]   # VERSION defaults to 0.0.0-dev
#
# The repo's plugin manifests carry no version (Claude Code then tracks
# commits); VERSION is written into the archive's copies only.
set -euo pipefail
cd "$(dirname "$0")/.."
version=${1:-0.0.0-dev}

rm -rf dist
mkdir -p dist/plugin

for dir in skills/*/; do
  name=$(basename "$dir")
  (cd skills && zip -qrX "../dist/$name.zip" "$name")
done

cp -R .codex-plugin .claude-plugin skills README.md dist/plugin/
rm dist/plugin/.claude-plugin/marketplace.json
python3 -I - "$version" dist/plugin/.codex-plugin/plugin.json dist/plugin/.claude-plugin/plugin.json <<'EOF'
import json, sys
version, *paths = sys.argv[1:]
for path in paths:
    with open(path) as f:
        manifest = json.load(f)
    manifest = {"name": manifest.pop("name"), "version": version, **manifest}
    with open(path, "w") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
        f.write("\n")
EOF
(cd dist/plugin && zip -qrX ../scc-skills.zip .)
rm -rf dist/plugin
ls -1 dist
