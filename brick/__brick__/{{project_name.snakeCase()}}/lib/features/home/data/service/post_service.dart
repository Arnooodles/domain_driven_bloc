import 'package:chopper/chopper.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/dto/reddit_post.dto.dart';

part 'post_service.chopper.dart';

@ChopperApi(baseUrl: 'https://reddit.com/r')
abstract interface class PostService extends ChopperService {
  @GET(path: '/FlutterDev.json')
  Future<Response<RedditPostDTO>> getPosts();

  static PostService create() => _$PostService();
}
