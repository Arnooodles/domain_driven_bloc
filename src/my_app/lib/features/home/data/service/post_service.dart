import 'package:chopper/chopper.dart';
import 'package:very_good_core/features/home/data/dto/post_list.dto.dart';

part 'post_service.chopper.dart';

@ChopperApi(baseUrl: 'https://dummyjson.com')
abstract interface class PostService extends ChopperService {
  @GET(path: '/posts')
  Future<Response<PostListDTO>> getPosts({@Query('limit') int limit = 20, @Query('skip') int skip = 0});

  static PostService create() => _$PostService();
}
