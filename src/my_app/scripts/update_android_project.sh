#!/bin/bash
# Update Gradle, Java and other Android project settings in a Flutter project

# To use `sed` on Windows install `sed for Windows` from https://gnuwin32.sourceforge.net/packages/sed.htm

# See: https://gradle.org/releases/
GRADLE_WRAPPER="9.0.0"
# Build errors often show the required Java version
JAVA_VERSION="21"
# The minimum Android SDK version
MIN_SDK_VERSION="26"
# Google Play Stores requires a minimum target SDK version
TARGET_SDK="36"
# The minimum compile SDK version
COMPILE_SDK="36"
# This shouldn't be too old, otherwise it won't compile with the GRADLE_WRAPPER set above
ANDROID_GRADLE_PLUGIN="8.12.1"
# The minimum Kotlin version
# See: https://kotlinlang.org/docs/gradle-configure-project.html#apply-the-plugin
KOTLIN_VERSION="2.2.20"
# See: https://developer.android.com/ndk/downloads
NDK_VERSION="29.0.14206865"


# Exit if this is not a Flutter project
if [ ! -f "pubspec.yaml" ]; then
  echo "This is not a Flutter project"
  exit 1
fi

# Exit if the Android directory does not exist
if [ ! -d "android" ]; then
  echo "The Android directory does not exist"
  exit 1
fi

# Navigate to the Android directory
cd android

# Determine the platform as Windows, Linux or MacOS since they have different sed syntax
OS=$(uname)
PLATFORM=""
if [[ "$OS" == "Linux" ]]; then 
  PLATFORM="linux"
elif [[ "$OS" == "Darwin" ]]; then 
  PLATFORM="macos"
elif [[ "$OS" == "CYGWIN"* || "$OS" == "MINGW"* || "$OS" == "MSYS"* ]]; then 
  PLATFORM="windows"
else 
  PLATFORM="unknown"
fi

# Update Gradle version (if specified)
if [ -n "$GRADLE_WRAPPER" ]; then
  echo "Updating Gradle version to $GRADLE_WRAPPER"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/gradle-.*-all.zip/gradle-${GRADLE_WRAPPER}-all.zip/" gradle/wrapper/gradle-wrapper.properties
  else
    sed -i '' "s/gradle-.*-all.zip/gradle-${GRADLE_WRAPPER}-all.zip/" gradle/wrapper/gradle-wrapper.properties
  fi
fi

# Update Java version (if specified)
if [ -n "$JAVA_VERSION" ]; then
  echo "Updating Java version to $JAVA_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/JavaVersion.VERSION_[0-9_]*/JavaVersion.VERSION_${JAVA_VERSION}/" app/build.gradle.kts
    sed -i "s/jvmToolchain(.*)/jvmToolchain(${JAVA_VERSION})/" app/build.gradle.kts
  else  
    sed -i '' "s/JavaVersion.VERSION_[0-9_]*/JavaVersion.VERSION_${JAVA_VERSION}/" app/build.gradle.kts
    sed -i '' "s/jvmToolchain(.*)/jvmToolchain(${JAVA_VERSION})/" app/build.gradle.kts
  fi
fi


# Update minSdk version (if specified)
if [ -n "$MIN_SDK_VERSION" ]; then
  echo "Updating minSdk version to $MIN_SDK_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/minSdk = Math.max(flutter.minSdkVersion, .*)/minSdk = Math.max(flutter.minSdkVersion, ${MIN_SDK_VERSION})/" app/build.gradle.kts
  else  
    sed -i '' "s/minSdk = Math.max(flutter.minSdkVersion, .*)/minSdk = Math.max(flutter.minSdkVersion, ${MIN_SDK_VERSION})/" app/build.gradle.kts
  fi
fi

# Update targetSdk version (if specified)
if [ -n "$TARGET_SDK" ]; then
  echo "Updating targetSdk version to $TARGET_SDK"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/targetSdk = Math.max(flutter.targetSdkVersion, .*)/targetSdk = Math.max(flutter.targetSdkVersion, ${TARGET_SDK})/" app/build.gradle.kts
  else  
    sed -i '' "s/targetSdk = Math.max(flutter.targetSdkVersion, .*)/targetSdk = Math.max(flutter.targetSdkVersion, ${TARGET_SDK})/" app/build.gradle.kts
  fi
fi

# Update compileSdk version (if specified)
if [ -n "$COMPILE_SDK" ]; then
  echo "Updating compileSdk version to $COMPILE_SDK"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/compileSdk = Math.max(flutter.compileSdkVersion, .*)/compileSdk = Math.max(flutter.compileSdkVersion, ${COMPILE_SDK})/" app/build.gradle.kts
  else  
    sed -i '' "s/compileSdk = Math.max(flutter.compileSdkVersion, .*)/compileSdk = Math.max(flutter.compileSdkVersion, ${COMPILE_SDK})/" app/build.gradle.kts
  fi
fi

# Update ndkVersion (if specified)
if [ -n "$NDK_VERSION" ]; then
  echo "Updating ndkVersion to $NDK_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/ndkVersion = \".*\"/ndkVersion = \"${NDK_VERSION}\"/" app/build.gradle.kts
  else  
    sed -i '' "s/ndkVersion = \".*\"/ndkVersion = \"${NDK_VERSION}\"/" app/build.gradle.kts
  fi
fi

# Update com.android.application version in settings.gradle (if specified)
if [ -n "$ANDROID_GRADLE_PLUGIN" ]; then
  echo "Updating com.android.application version to $ANDROID_GRADLE_PLUGIN"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/id (\"com.android.application\") version \".*\" apply false/id (\"com.android.application\") version \"${ANDROID_GRADLE_PLUGIN}\" apply false/" settings.gradle.kts
  else  
    sed -i '' "s/id (\"com.android.application\") version \".*\" apply false/id (\"com.android.application\") version \"${ANDROID_GRADLE_PLUGIN}\" apply false/" settings.gradle.kts
  fi
fi

if [ -n "$KOTLIN_VERSION" ]; then
  echo "Updating org.jetbrains.kotlin.android to $KOTLIN_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/id (\"org.jetbrains.kotlin.android\") version \".*\" apply false/id (\"org.jetbrains.kotlin.android\") version \"${KOTLIN_VERSION}\" apply false/" settings.gradle.kts
  else  
    sed -i '' "s/id (\"org.jetbrains.kotlin.android\") version \".*\" apply false/id (\"org.jetbrains.kotlin.android\") version \"${KOTLIN_VERSION}\" apply false/" settings.gradle.kts
  fi
fi

echo "Android project updated. Run 'git diff' to see the changes or 'git reset --hard' to discard them."
