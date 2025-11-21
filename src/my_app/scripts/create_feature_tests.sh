#!/bin/zsh

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if ! validate_or_prompt_feature_name "$@"; then
  print_usage "Creates test folders under test/unit/features/<feature_name> and test/widget/features/<feature_name>"
  exit 1
fi

FEATURE_NAME_SNAKE=$(to_snake_case "$INPUT_NAME")

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


