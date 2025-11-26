#!/bin/zsh

# Common utility functions for feature creation scripts

# Print usage message
# Usage: print_usage <description>
print_usage() {
  local description="$1"
  echo "Usage: $0 <FeatureName>" 1>&2
  echo "$description" 1>&2
}

# Validate or prompt for feature name
# Sets INPUT_NAME variable or returns non-zero on error
# Usage: validate_or_prompt_feature_name [feature_name]
validate_or_prompt_feature_name() {
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
    return 1
  fi

  return 0
}

# Convert to snake_case (underscore_case) per project naming rules
# - Insert underscore between lower->Upper transitions
# - Replace non-alphanumeric with underscores
# - Lowercase and collapse duplicate underscores
# Usage: to_snake_case <string>
to_snake_case() {
  local s="$1"
  # Handle camelCase/PascalCase boundaries, non-alnum, and lowercase
  s=$(echo "$s" | sed -E 's/([a-z0-9])([A-Z])|([A-Z])([A-Z][a-z])/\1\3_\2\4/g')
  s=$(echo "$s" | sed -E 's/[^a-zA-Z0-9]+/_/g')
  s=$(echo "$s" | tr '[:upper:]' '[:lower:]')
  s=$(echo "$s" | sed -E 's/^_+|_+$//g; s/__+/_/g')
  echo "$s"
}

