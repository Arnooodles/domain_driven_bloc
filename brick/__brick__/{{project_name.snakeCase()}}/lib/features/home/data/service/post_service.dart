import 'package:chopper/chopper.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/post_list.dto.dart';

part 'post_service.chopper.dart';

@ChopperApi()
abstract interface class PostService extends ChopperService {
  @GET(path: '/posts')
  Future<Response<PostListDTO>> getPosts({@Query('limit') int limit = 20, @Query('skip') int skip = 0});

  static PostService create() => _$PostService();
}
