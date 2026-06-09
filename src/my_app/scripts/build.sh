#!/bin/bash

# =============================================================================
# build.sh
# Builds a Flutter Android (APK/AAB) or iOS (IPA) artifact with flavor support.
#
# Usage:
#   ./scripts/build.sh [OPTIONS]
#
# Options:
#   -p, --platform        Platform: android | ios                       (required)
#   -f, --flavor          Flavor: development | staging | production    (default: development)
#   -t, --type            Output type: apk | appbundle  [android only]  (default: apk)
#   -b, --build-type      Build type: debug | release                   (default: release)
#   -c, --build-number    Build number, e.g. 42                         (required)
#   -h, --help            Show this help message
# =============================================================================

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
PLATFORM=""
FLAVOR="development"
OUTPUT_TYPE="apk"
BUILD_TYPE="release"
BUILD_NUMBER=""

# ── Usage ─────────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -p, --platform        Platform: android | ios                       (required)
  -f, --flavor          Flavor: development | staging | production    (default: development)
  -t, --type            Output type: apk | appbundle  [android only]  (default: apk)
  -b, --build-type      Build type: debug | release                   (default: release)
  -c, --build-number    Build number, e.g. 42                         (required)
  -h, --help            Show this help

Examples:
  $0 --platform android --flavor staging --type apk --build-number 42
  $0 --platform android --flavor production --type appbundle --build-number 100
  $0 --platform ios --flavor staging --build-number 42
  $0 --platform ios --flavor production --build-number 100
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--platform)
      PLATFORM="$2"; shift 2 ;;
    -f|--flavor)
      FLAVOR="$2"; shift 2 ;;
    -t|--type)
      OUTPUT_TYPE="$2"; shift 2 ;;
    -b|--build-type)
      BUILD_TYPE="$2"; shift 2 ;;
    -c|--build-number)
      BUILD_NUMBER="$2"; shift 2 ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown option: $1"; usage; exit 1 ;;
  esac
done

# ── Validate required args ────────────────────────────────────────────────────
if [[ -z "$PLATFORM" ]]; then
  echo "Error: --platform is required."
  usage; exit 1
fi

# ── Validate flavor ───────────────────────────────────────────────────────────
case "$FLAVOR" in
  development|staging|production) ;;
  *) echo "Invalid flavor: '$FLAVOR'. Must be one of: development, staging, production"; exit 1 ;;
esac

# ── Resolve build number for production from pubspec.yaml ─────────────────────
if [[ "$FLAVOR" == "production" ]]; then
  BUILD_NUMBER=$(grep '^version:' pubspec.yaml | sed 's/version: //; s/.*+//' | tr -d '[:space:]')
fi

if [[ -z "$BUILD_NUMBER" ]]; then
  echo "Error: --build-number is required."
  usage; exit 1
fi

# ── Validate platform ─────────────────────────────────────────────────────────
case "$PLATFORM" in
  android|ios) ;;
  *) echo "Invalid platform: '$PLATFORM'. Must be one of: android, ios"; exit 1 ;;
esac

# ── Validate build type ───────────────────────────────────────────────────────
case "$BUILD_TYPE" in
  debug|release) ;;
  *) echo "Invalid build-type: '$BUILD_TYPE'. Must be one of: debug, release"; exit 1 ;;
esac

# ── Validate output type (android only) ──────────────────────────────────────
if [[ "$PLATFORM" == "android" ]]; then
  case "$OUTPUT_TYPE" in
    apk|appbundle) ;;
    *) echo "Invalid type: '$OUTPUT_TYPE'. Must be one of: apk, appbundle"; exit 1 ;;
  esac
fi

# ── Resolve app name, version & suffix ────────────────────────────────────────
APP_NAME=$(grep '^name:' pubspec.yaml | sed 's/name: //' | tr -d '[:space:]')
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //; s/+.*//' | tr -d '[:space:]')
SUFFIX=""
if [[ "$BUILD_TYPE" == "debug" ]]; then
  SUFFIX="-debug"
fi
echo "App:      $APP_NAME"
echo "Platform: $PLATFORM"
echo "Flavor:   $FLAVOR"
echo "Version:  $VERSION+$BUILD_NUMBER"
echo ""

# ── Build ─────────────────────────────────────────────────────────────────────
if [[ "$PLATFORM" == "android" ]]; then
  echo "Building Flutter $OUTPUT_TYPE ($FLAVOR:$BUILD_TYPE)..."

  BUILD_ARGS=(
    "build" "$OUTPUT_TYPE"
    "--flavor" "$FLAVOR"
    "--$BUILD_TYPE"
    "--build-name=$VERSION"
    "--build-number=$BUILD_NUMBER"
  )

  if [[ "$BUILD_TYPE" == "release" ]]; then
    BUILD_ARGS+=(
      "--obfuscate"
      "--split-debug-info=build/debug-info"
    )
  fi

  flutter "${BUILD_ARGS[@]}"

  # ── Copy artifact to outputs/ ───────────────────────────────────────────────
  if [[ "$OUTPUT_TYPE" == "appbundle" ]]; then
    BUILD_TYPE_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${BUILD_TYPE:0:1})${BUILD_TYPE:1}"
    SRC="build/app/outputs/bundle/${FLAVOR}${BUILD_TYPE_CAP}/app-${FLAVOR}-${BUILD_TYPE}.aab"
    ARTIFACT_NAME="${APP_NAME}-${FLAVOR}${SUFFIX}-${VERSION}+${BUILD_NUMBER}.aab"
  else
    SRC="build/app/outputs/flutter-apk/app-${FLAVOR}-${BUILD_TYPE}.apk"
    ARTIFACT_NAME="${APP_NAME}-${FLAVOR}${SUFFIX}-${VERSION}+${BUILD_NUMBER}.apk"
  fi

  mkdir -p outputs
  cp "$SRC" "outputs/$ARTIFACT_NAME"
  rm -rf "$(dirname "$SRC")"

else
  echo "Building Flutter ipa ($FLAVOR:$BUILD_TYPE)..."

  EXPORT_OPTIONS_PLIST="ios/ExportOptions/ExportOptions-${FLAVOR}.plist"

  BUILD_ARGS=(
    "build" "ipa"
    "--flavor" "$FLAVOR"
    "--$BUILD_TYPE"
    "--export-options-plist=$EXPORT_OPTIONS_PLIST"
    "--build-name=$VERSION"
    "--build-number=$BUILD_NUMBER"
  )

  if [[ "$BUILD_TYPE" == "debug" ]]; then
    BUILD_ARGS+=(
      "--no-codesign"
    )
  fi

  flutter "${BUILD_ARGS[@]}"

  # ── Copy artifact to outputs/ ───────────────────────────────────────────────
  if [[ "$BUILD_TYPE" == "debug" ]]; then
    ARCHIVE_SRC=$(find "build/ios/archive" -name "*.xcarchive" 2>/dev/null | head -n 1)

    if [[ -z "$ARCHIVE_SRC" ]]; then
      echo "Error: XCArchive artifact not found under build/ios/archive/. Build may have failed."
      exit 1
    fi

    ARTIFACT_NAME="${APP_NAME}-${FLAVOR}${SUFFIX}-${VERSION}+${BUILD_NUMBER}.xcarchive"
    mkdir -p outputs
    cp -R "$ARCHIVE_SRC" "outputs/$ARTIFACT_NAME"
    rm -rf "build/ios/archive"
  else
    IPA_SRC=$(find "build/ios/ipa" -name "*.ipa" 2>/dev/null | head -n 1)

    if [[ -z "$IPA_SRC" ]]; then
      echo "Error: IPA artifact not found under build/ios/ipa/. Build may have failed."
      exit 1
    fi

    ARTIFACT_NAME="${APP_NAME}-${FLAVOR}${SUFFIX}-${VERSION}+${BUILD_NUMBER}.ipa"
    mkdir -p outputs
    cp "$IPA_SRC" "outputs/$ARTIFACT_NAME"
    rm -rf "build/ios/ipa"
  fi
fi

echo ""
echo "Build completed!"
echo "Artifact: outputs/$ARTIFACT_NAME"
