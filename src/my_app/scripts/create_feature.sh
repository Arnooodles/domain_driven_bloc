#!/bin/zsh

set -euo pipefail

print_usage() {
  echo "Usage: $0 <FeatureName>" 1>&2
  echo "Creates Clean Architecture folders under lib/features/<feature_name>" 1>&2
}

if [ $# -lt 1 ]; then
  # Portable prompt: print then read (works in bash/zsh/sh)
  printf "Enter feature name: "
  IFS= read -r INPUT_NAME
else
  INPUT_NAME="$1"
fi

# Validate non-empty input after trimming spaces
if [ -z "${INPUT_NAME// }" ]; then
  echo "Error: feature name is required." 1>&2
  print_usage
  exit 1
fi

# Convert to snake_case (underscore_case) per project naming rules
# - Insert underscore between lower->Upper transitions
# - Replace non-alphanumeric with underscores
# - Lowercase and collapse duplicate underscores
to_snake_case() {
  local s="$1"
  # Handle camelCase/PascalCase boundaries, non-alnum, and lowercase
  s=$(echo "$s" | sed -E 's/([a-z0-9])([A-Z])|([A-Z])([A-Z][a-z])/\1\3_\2\4/g')
  s=$(echo "$s" | sed -E 's/[^a-zA-Z0-9]+/_/g')
  s=$(echo "$s" | tr '[:upper:]' '[:lower:]')
  s=$(echo "$s" | sed -E 's/^_+|_+$//g; s/__+/_/g')
  echo "$s"
}

FEATURE_NAME_SNAKE=$(to_snake_case "$INPUT_NAME")

# Determine repo root based on this script's location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
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


