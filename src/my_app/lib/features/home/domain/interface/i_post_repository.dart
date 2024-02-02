import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/entity/failure.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
