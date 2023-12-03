import 'package:fpdart/fpdart.dart';

extension EitherExt<L, R> on Either<L, R> {
  R asRight() => (this as Right<L, R>).value;
  L asLeft() => (this as Left<L, R>).value;
}
