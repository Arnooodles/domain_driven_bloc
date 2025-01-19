#!/bin/bash
# Update Gradle, Java and other Android project settings in a Flutter project

# To use `sed` on Windows install `sed for Windows` from https://gnuwin32.sourceforge.net/packages/sed.htm

# See: https://gradle.org/releases/
DESIRED_GRADLE_VERSION="8.10.2"
# Build errors often show the required Java version
DESIRED_JAVA_VERSION="18"
# The minimum Android SDK version
DESIRED_MIN_SDK_VERSION="26"
# Google Play Stores requires a minimum target SDK version
DESIRED_TARGET_SDK="34"
# The minimum compile SDK version
DESIRED_COMPILE_SDK="34"
# This shouldn't be too old, otherwise it won't compile with the DESIRED_GRADLE_VERSION set above
DESIRED_ANDROID_APPLICATION_VERSION="8.7.0"
# The minimum Kotlin version
DESIRED_KOTLIN_VERSION="1.8.22"

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
if [ -n "$DESIRED_GRADLE_VERSION" ]; then
  echo "Updating Gradle version to $DESIRED_GRADLE_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/gradle-.*-all.zip/gradle-${DESIRED_GRADLE_VERSION}-all.zip/" gradle/wrapper/gradle-wrapper.properties
  else
    sed -i '' "s/gradle-.*-all.zip/gradle-${DESIRED_GRADLE_VERSION}-all.zip/" gradle/wrapper/gradle-wrapper.properties
  fi
fi

# Update Java version (if specified)
if [ -n "$DESIRED_JAVA_VERSION" ]; then
  echo "Updating Java version to $DESIRED_JAVA_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/JavaVersion.VERSION_[0-9_]*/JavaVersion.VERSION_${DESIRED_JAVA_VERSION}/" app/build.gradle.kts
    sed -i "s/jvmToolchain(.*)/jvmToolchain(${DESIRED_JAVA_VERSION})/" app/build.gradle.kts
  else  
    sed -i '' "s/JavaVersion.VERSION_[0-9_]*/JavaVersion.VERSION_${DESIRED_JAVA_VERSION}/" app/build.gradle.kts
    sed -i '' "s/jvmToolchain(.*)/jvmToolchain(${DESIRED_JAVA_VERSION})/" app/build.gradle.kts
  fi
fi


# Update minSdk version (if specified)
if [ -n "$DESIRED_MIN_SDK_VERSION" ]; then
  echo "Updating minSdk version to $DESIRED_MIN_SDK_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/minSdk = Math.max(flutter.minSdkVersion, .*)/minSdk = Math.max(flutter.minSdkVersion, ${DESIRED_MIN_SDK_VERSION})/" app/build.gradle.kts
  else  
    sed -i "s/minSdk = Math.max(flutter.minSdkVersion, .*)/minSdk = Math.max(flutter.minSdkVersion, ${DESIRED_MIN_SDK_VERSION})/" app/build.gradle.kts
  fi
fi

# Update targetSdk version (if specified)
if [ -n "$DESIRED_TARGET_SDK" ]; then
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/targetSdk = Math.max(flutter.targetSdkVersion, .*)/targetSdk = Math.max(flutter.targetSdkVersion, ${DESIRED_TARGET_SDK})/" app/build.gradle.kts
  else  
    sed -i '' "s/targetSdk = Math.max(flutter.targetSdkVersion, .*)/targetSdk = Math.max(flutter.targetSdkVersion, ${DESIRED_TARGET_SDK})/" app/build.gradle.kts
  fi
fi

# Update compileSdk version (if specified)
if [ -n "$DESIRED_COMPILE_SDK" ]; then
  echo "Updating compileSdk version to $DESIRED_COMPILE_SDK"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/compileSdk = Math.max(flutter.compileSdkVersion, .*)/compileSdk = Math.max(flutter.compileSdkVersion, ${DESIRED_COMPILE_SDK})/" app/build.gradle.kts
  else  
    sed -i '' "s/compileSdk = Math.max(flutter.compileSdkVersion, .*)/compileSdk = Math.max(flutter.compileSdkVersion, ${DESIRED_COMPILE_SDK})/" app/build.gradle.kts
  fi
fi

# Update com.android.application version in settings.gradle (if specified)
if [ -n "$DESIRED_ANDROID_APPLICATION_VERSION" ]; then
echo "Updating com.android.application version to $DESIRED_ANDROID_APPLICATION_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/id (\"com.android.application\") version \".*\" apply false/id (\"com.android.application\") version \"${DESIRED_ANDROID_APPLICATION_VERSION}\" apply false/" settings.gradle.kts
  else  
    sed -i '' "s/id (\"com.android.application\") version \".*\" apply false/id (\"com.android.application\") version \"${DESIRED_ANDROID_APPLICATION_VERSION}\" apply false/" settings.gradle.kts
  fi
fi

if [ -n "$DESIRED_KOTLIN_VERSION" ]; then
echo "Updating org.jetbrains.kotlin.android to $DESIRED_KOTLIN_VERSION"
  if [[ "$PLATFORM" == "windows" ]]; then
    sed -i "s/id (\"org.jetbrains.kotlin.android\") version \".*\" apply false/id (\"org.jetbrains.kotlin.android\") version \"${DESIRED_KOTLIN_VERSION}\" apply false/" settings.gradle.kts
  else  
    sed -i '' "s/id (\"org.jetbrains.kotlin.android\") version \".*\" apply false/id (\"org.jetbrains.kotlin.android\") version \"${DESIRED_KOTLIN_VERSION}\" apply false/" settings.gradle.kts
  fi
fi

echo "Android project updated. Run 'git diff' to see the changes or 'git reset --hard' to discard them."
