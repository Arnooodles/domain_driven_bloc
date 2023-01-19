import 'package:dartz/dartz.dart';
import 'package:my_app/core/domain/model/failures.dart';
import 'package:my_app/features/home/domain/model/post.dart';

abstract class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
