import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/generated/assets.gen.dart';
import 'package:very_good_core/core/domain/interface/i_asset_repository.dart';

@LazySingleton(as: IAssetRepository)
class AssetRepository implements IAssetRepository {
  @override
  Future<void> preloadSVGs() async {
    final List<Future<void>> futures = <Future<void>>[];
    for (final String path in getSvgAssets()) {
      final SvgAssetLoader loader = SvgAssetLoader(path);
      futures.add(svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null)));
    }
    await Future.wait(futures);
  }

  @visibleForTesting
  List<String> getSvgAssets() => <String>[
    ..._filterSvgAssets(Assets.images.values),
    ..._filterSvgAssets(Assets.icons.values),
  ];

  List<String> _filterSvgAssets(List<dynamic> assetPaths) =>
      assetPaths.whereType<String>().where((String path) => path.endsWith('.svg')).toList();
}
