import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
