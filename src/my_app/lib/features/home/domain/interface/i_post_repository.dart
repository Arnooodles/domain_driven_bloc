import 'package:very_good_core/core/domain/entity/typedef.dart';
import 'package:very_good_core/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  Future<Result<List<Post>>> getPosts();
}
