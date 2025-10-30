#!/bin/zsh

set -euo pipefail

print_usage() {
  echo "Usage: $0 <FeatureName>" 1>&2
  echo "Creates test folders under test/unit/features/<feature_name> and test/widget/features/<feature_name>" 1>&2
}

if [ $# -lt 1 ]; then
  printf "Enter feature name: "
  IFS= read -r INPUT_NAME
else
  INPUT_NAME="$1"
fi

if [ -z "${INPUT_NAME// }" ]; then
  echo "Error: feature name is required." 1>&2
  print_usage
  exit 1
fi

to_snake_case() {
  local s="$1"
  s=$(echo "$s" | sed -E 's/([a-z0-9])([A-Z])|([A-Z])([A-Z][a-z])/\1\3_\2\4/g')
  s=$(echo "$s" | sed -E 's/[^a-zA-Z0-9]+/_/g')
  s=$(echo "$s" | tr '[:upper:]' '[:lower:]')
  s=$(echo "$s" | sed -E 's/^_+|_+$//g; s/__+/_/g')
  echo "$s"
}

FEATURE_NAME_SNAKE=$(to_snake_case "$INPUT_NAME")

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

UNIT_ROOT="$REPO_ROOT/test/unit/features/$FEATURE_NAME_SNAKE"
WIDGET_ROOT="$REPO_ROOT/test/widget/features/$FEATURE_NAME_SNAKE"

echo "Creating test scaffolding for feature: $FEATURE_NAME_SNAKE"

dirs=(
  "$UNIT_ROOT/cubit"
  "$UNIT_ROOT/repository"
  "$WIDGET_ROOT"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
  if [ ! -f "$d/.gitkeep" ]; then
    touch "$d/.gitkeep"
  fi
done

echo "✅ Test scaffold created"
printf "\n"
printf "test\n"
printf "├── unit\n"
printf "│   └── features\n"
printf "│       └── %s\n" "$FEATURE_NAME_SNAKE"
printf "│           ├── cubit\n"
printf "│           └── repository\n"
printf "└── widget\n"
printf "    └── features\n"
printf "        └── %s\n" "$FEATURE_NAME_SNAKE"


