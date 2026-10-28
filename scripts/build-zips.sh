#!/usr/bin/env bash
# Builds upload-ready zips into dist/: one per skill (claude.ai, ChatGPT and
# Grok take one skill folder per zip) plus scc-skills.zip holding all seven.
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf dist
mkdir -p dist/stage/scc-skills

for dir in skills/*/; do
  name=$(basename "$dir")
  (cd skills && zip -qrX "../dist/$name.zip" "$name")
  cp -R "$dir" "dist/stage/scc-skills/$name"
done

(cd dist/stage && zip -qrX ../scc-skills.zip scc-skills)
rm -rf dist/stage
ls -1 dist
