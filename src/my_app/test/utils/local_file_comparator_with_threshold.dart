import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Works just like [LocalFileComparator] but includes a [_threshold] that, when
/// exceeded, marks the test as a failure.
class LocalFileComparatorWithThreshold extends LocalFileComparator {
  LocalFileComparatorWithThreshold(super.testFile, this._threshold)
    : assert(_threshold >= 0 && _threshold <= 1, 'Threshold must be between 0 to 1');

  /// Threshold above which tests will be marked as failing.
  /// Ranges from 0 to 1, both inclusive.
  final double _threshold;

  /// Copy of [LocalFileComparator]'s [compare] method, except for the fact that
  /// it checks if the [ComparisonResult.diffPercent] is not greater than
  /// [_threshold] to decide whether this test is successful or a failure.
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final ComparisonResult result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));

    if (!result.passed && result.diffPercent <= _threshold) {
      debugPrint(
        'A difference of ${result.diffPercent * 100}% was found, but it is '
        'acceptable since it is not greater than the threshold of '
        '${_threshold * 100}%',
      );

      return true;
    }

    if (!result.passed) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }

    return result.passed;
  }
}
