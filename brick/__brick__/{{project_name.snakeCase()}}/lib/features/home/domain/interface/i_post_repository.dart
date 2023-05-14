import 'package:fpdart/fpdart.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/failure.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/model/post.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
