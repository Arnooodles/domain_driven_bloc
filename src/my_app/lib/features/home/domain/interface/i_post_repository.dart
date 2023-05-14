import 'package:fpdart/fpdart.dart';
import 'package:very_good_core/core/domain/model/failure.dart';
import 'package:very_good_core/features/home/domain/model/post.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
