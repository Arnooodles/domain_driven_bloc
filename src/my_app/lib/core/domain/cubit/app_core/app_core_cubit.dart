// ignore_for_file: avoid_flutter_imports

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_core/app/helpers/extensions/cubit_ext.dart';
import 'package:very_good_core/app/helpers/mixins/failure_handler.dart';
import 'package:very_good_core/core/domain/interface/i_asset_repository.dart';

part 'app_core_cubit.freezed.dart';
part 'app_core_state.dart';

@lazySingleton
class AppCoreCubit extends Cubit<AppCoreState> {
  AppCoreCubit(this._failureHandler, this._assetRepository) : super(AppCoreState.initial());

  final FailureHandler _failureHandler;
  final IAssetRepository _assetRepository;

  Future<void> initialize() async {
    await safeRun(action: _assetRepository.preloadSVGs, onException: _failureHandler.handleException);
  }
}
