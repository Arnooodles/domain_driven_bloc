import 'package:dartx/dartx.dart';

extension ObjectExt<T> on T? {
  R? let<R>(R Function(T) op) {
    if (this is String?) {
      return (this as String?).isNotNullOrBlank ? op(this as T) : null;
    } else {
      return this != null ? op(this as T) : null;
    }
  }
}
