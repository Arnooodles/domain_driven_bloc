// ignore_for_file: prefer-match-file-name

import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';

extension EitherExt<L, R> on Either<L, R> {
  R asRight() => (this as Right<L, R>).value;
  L asLeft() => (this as Left<L, R>).value;
}

extension ResultExt<T> on Result<T> {
  T asRight() => (this as Right<Failure, T>).value;
  Failure asLeft() => (this as Left<Failure, T>).value;
}

extension OptionExt<T> on Option<T> {
  T asSome() => (this as Some<T>).value;
}
