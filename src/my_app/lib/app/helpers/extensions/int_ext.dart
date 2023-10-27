import 'package:very_good_core/app/constants/enum.dart';

extension IntExt on int {
  StatusCode get statusCode => StatusCode.values.firstWhere(
        (StatusCode element) => element.value == this,
        orElse: () => StatusCode.http000,
      );
}
