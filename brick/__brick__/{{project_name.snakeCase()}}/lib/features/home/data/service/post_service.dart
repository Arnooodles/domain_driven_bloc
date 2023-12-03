import 'package:chopper/chopper.dart';

part 'post_service.chopper.dart';

@ChopperApi(baseUrl: '/r')
abstract interface class PostService extends ChopperService {
  @Get(path: '/FlutterDev.json')
  Future<Response<dynamic>> getPosts();

  static PostService create() => _$PostService();
}
