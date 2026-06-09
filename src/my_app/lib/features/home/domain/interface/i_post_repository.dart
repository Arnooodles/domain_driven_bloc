import 'package:very_good_core/app/constants/constant.dart';
import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  TaskResult<List<Post>> getPosts({
    int skip = 0,
    int limit = Constant.defaultPaginationLimit,
    bool forceRefresh = true,
  });
}
