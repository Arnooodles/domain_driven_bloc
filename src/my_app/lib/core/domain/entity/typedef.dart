import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';

// ============================================================================
// Result Types
// ============================================================================

/// A result type that represents either a Failure or a successful value of type T.
///
/// This is a semantic alias for `Either<Failure, T>` that makes the intent clearer
typedef Result<T> = Either<Failure, T>;
typedef TaskResult<T> = TaskEither<Failure, T>;

// ============================================================================
// JSON Types
// ============================================================================

/// A JSON object represented as a Map with String keys and dynamic values.
///
/// This is the standard type for JSON serialization/deserialization in Dart.
typedef Json = Map<String, dynamic>;
