import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/typedef.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  TaskResult<List<Post>> getPosts({
    int skip = 0,
    int limit = Constant.defaultPaginationLimit,
    bool forceRefresh = true,
  });
}
