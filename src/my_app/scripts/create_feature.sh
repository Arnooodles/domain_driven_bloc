#!/bin/zsh

set -euo pipefail

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

if ! validate_or_prompt_feature_name "$@"; then
  print_usage "Creates Clean Architecture folders under lib/features/<feature_name>"
  exit 1
fi

FEATURE_NAME_SNAKE=$(to_snake_case "$INPUT_NAME")

# Determine repo root based on this script's location
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FEATURE_ROOT="$REPO_ROOT/lib/features/$FEATURE_NAME_SNAKE"

echo "Creating feature: $FEATURE_NAME_SNAKE"
echo "Root: $FEATURE_ROOT"

dirs=(
  "$FEATURE_ROOT/data/dto"
  "$FEATURE_ROOT/data/repository"
  "$FEATURE_ROOT/data/service"
  "$FEATURE_ROOT/domain/cubit"
  "$FEATURE_ROOT/domain/interface"
  "$FEATURE_ROOT/domain/entity"
  "$FEATURE_ROOT/presentation/views"
  "$FEATURE_ROOT/presentation/widgets"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
  # Ensure Git tracks empty dirs
  if [ ! -f "$d/.gitkeep" ]; then
    touch "$d/.gitkeep"
  fi
done

echo "✅ Feature scaffold created at lib/features/$FEATURE_NAME_SNAKE"
echo "Structure:"
printf "\n"
printf "lib\n"
printf "└── features\n"
printf "    └── %s\n" "$FEATURE_NAME_SNAKE"
printf "        ├── data\n"
printf "        │   ├── dto\n"
printf "        │   ├── repository\n"
printf "        │   └── service\n"
printf "        ├── domain\n"
printf "        │   ├── cubit\n"
printf "        │   ├── interface\n"
printf "        │   └── entity\n"
printf "        └── presentation\n"
printf "            ├── views\n"
printf "            └── widgets\n"


