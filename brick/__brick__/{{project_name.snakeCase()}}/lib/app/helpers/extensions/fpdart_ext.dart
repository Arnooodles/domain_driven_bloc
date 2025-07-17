// ignore_for_file: prefer-match-file-name

import 'package:fpdart/fpdart.dart';

extension EitherExt<L, R> on Either<L, R> {
  R asRight() => (this as Right<L, R>).value;
  L asLeft() => (this as Left<L, R>).value;
}

extension OptionExt<T> on Option<T> {
  T asSome() => (this as Some<T>).value;
}
