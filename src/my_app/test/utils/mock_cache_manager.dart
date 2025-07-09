// ignore_for_file: depend_on_referenced_packages

import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';

class MockCacheManager extends Mock implements BaseCacheManager {
  static const LocalFileSystem fileSystem = LocalFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
    int? maxHeight,
    int? maxWidth,
  }) async* {
    yield FileInfo(fileSystem.file(url), FileSource.Cache, DateTime(3050), url);
  }
}

class InvalidCacheManager extends Mock implements BaseCacheManager {
  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
    int? maxHeight,
    int? maxWidth,
  }) async* {
    throw Exception('Cannot download file');
  }
}
