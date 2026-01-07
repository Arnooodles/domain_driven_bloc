import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  Future<Result<List<Post>>> getPosts();
}
