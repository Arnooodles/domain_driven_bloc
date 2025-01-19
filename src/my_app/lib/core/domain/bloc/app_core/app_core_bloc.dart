import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/generated/assets.gen.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/core/domain/entity/enum/app_scroll_controller.dart';

part 'app_core_bloc.freezed.dart';
part 'app_core_state.dart';

@lazySingleton
class AppCoreBloc extends Cubit<AppCoreState> {
  AppCoreBloc() : super(AppCoreState.initial());

  Future<void> initialize() async {
    await _preloadSVG(_getSvgAssets());
  }

  List<String> _getSvgAssets() => <String>[
        ..._filterSvgAssets(Assets.images.values),
        ..._filterSvgAssets(Assets.icons.values),
      ];

  Future<void> _preloadSVG(List<String> assetPaths) async {
    for (final String path in assetPaths) {
      final SvgAssetLoader loader = SvgAssetLoader(path);
      unawaited(
        svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        ),
      );
    }
  }

  List<String> _filterSvgAssets(List<dynamic> assetPaths) => assetPaths
      .whereType<String>()
      .toList()
      .where((String path) => path.contains('.svg'))
      .toList();

  void setScrollControllers(
    Map<AppScrollController, ScrollController> scrollControllers,
  ) =>
      safeEmit(state.copyWith(scrollControllers: scrollControllers));
}
