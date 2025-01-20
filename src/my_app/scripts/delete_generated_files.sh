#!/bin/bash

patterns=(
    "**/*.g.dart"
    "**/*.freezed.dart"
    "**/*.config.dart"
    "**/*.chopper.dart"
    "**/*.mocks.dart"
    "lib/app/generated/**/*.dart"
    "lib/app/generated/**"
    "lib/**/generated_plugin_registrant.dart"
)

for pattern in "${patterns[@]}"; do
    find . -path "$pattern" -type f -exec echo "Deleting file: {}" \; -exec rm -f {} \;
    find . -path "$pattern" -type d -exec echo "Deleting directory: {}" \; -exec rmdir {} \;
done