#!/usr/bin/env bash
# Checks every skill's version. metadata.version in the frontmatter must
# match the `<name> v<version>` line the body tells the agent to print, and
# a skill whose SKILL.md differs from BASE must carry a new version.
#
#   scripts/check-versions.sh [BASE]   # BASE defaults to HEAD
#
# Prints one "<name>: v<old> -> v<new>" line per bumped skill.
set -euo pipefail
cd "$(dirname "$0")/.."
base=${1:-HEAD}
fail=0

version_of() { # metadata.version of the SKILL.md on stdin
  awk -F: '/^---$/ { n++; next } n == 1 && /^  version:/ { gsub(/[" ]/, "", $2); print $2; exit }'
}

for file in skills/*/SKILL.md; do
  name=$(basename "$(dirname "$file")")
  new=$(version_of <"$file")

  if [ -z "$new" ]; then
    echo "$name: no metadata.version in the frontmatter" >&2
    fail=1
    continue
  fi
  if ! grep -qF "\`$name v$new\`" "$file"; then
    echo "$name: body doesn't announce \`$name v$new\`; update its version line" >&2
    fail=1
  fi

  if git cat-file -e "$base:$file" 2>/dev/null && ! git diff --quiet "$base" -- "$file"; then
    old=$(git show "$base:$file" | version_of)
    if [ "$old" = "$new" ]; then
      echo "$name: changed since $base but still v$new; bump metadata.version" >&2
      fail=1
    else
      echo "$name: v${old:-none} -> v$new"
    fi
  fi
done

exit $fail
