import 'package:dartx/dartx.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/value_object.dart';

extension ObjectExt<T> on T? {
  R? let<R>(R Function(T) op) {
    // ignore: prefer-conditional-expressions
    if (this is String?) {
      return (this as String?).isNotNullOrBlank ? op(this as T) : null;
    } else {
      return this != null ? op(this as T) : null;
    }
  }
}

extension NullableValueObjectX<T> on ValueObject<T>? {
  Either<Failure, Unit> optionalValidation() => this?.validate ?? right(unit);
}
