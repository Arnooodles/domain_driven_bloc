import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/app/themes/app_text_style.dart';
import 'package:very_good_core/app/themes/app_theme.dart';

import 'utils/local_file_comparator_with_threshold.dart';
import 'utils/test_utils.dart';

// ignore_for_file: avoid_redundant_argument_values,prefer-match-file-name
class TestConfig {
  /// Added a goldens version to know when the golden files were last updated
  /// To update the golden files in the remote repository change goldensVersion
  /// Format: yyyyMMdd
  static String get goldensVersion => '20250717';

  /// Customize your threshold here
  /// For example, the error threshold here is 15%
  /// Golden tests will pass if the pixel difference is equal to or below 15%
  static double get goldenTestsThreshold => 15 / 100;
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await Future.wait(<Future<void>>[setupInjection()]);

  if (goldenFileComparator is LocalFileComparator) {
    final Uri testUrl = (goldenFileComparator as LocalFileComparator).basedir;

    goldenFileComparator = LocalFileComparatorWithThreshold(
      // flutter_test's LocalFileComparator expects the test's URI to be passed
      // as an argument, but it only uses it to parse the baseDir in order to
      // obtain the directory where the golden tests will be placed.
      // As such, we use the default `testUrl`, which is only the `baseDir` and
      // append a generically named `test.dart` so that the `baseDir` is
      // properly extracted.
      Uri.parse('$testUrl/test.dart'),
      TestConfig.goldenTestsThreshold,
    );
  } else {
    throw Exception(
      'Expected `goldenFileComparator` to be of type `LocalFileComparator`, '
      'but it is of type `${goldenFileComparator.runtimeType}`',
    );
  }

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      goldenTestTheme:
          GoldenTestTheme.standard().copyWith(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                nameTextStyle: AppTextStyle.baseTextStyle,
              )
              as GoldenTestTheme,
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !const bool.fromEnvironment('CI', defaultValue: false),
        theme: AppTheme.light,
      ),
      ciGoldensConfig: CiGoldensConfig(theme: AppTheme.light),
    ),
    run: testMain,
  );
}
