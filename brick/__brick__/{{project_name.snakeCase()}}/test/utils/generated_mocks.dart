// ignore_for_file: no-empty-block

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/mixins/failure_handler.dart';
import 'package:{{project_name.snakeCase()}}/core/data/service/user_service.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/app_core/app_core_cubit.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/app_localization/app_localization_cubit.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/cubit/hidable/hidable_cubit.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_app_localization_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_asset_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/service/auth_service.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/cubit/auth/auth_cubit.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/service/post_service.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/cubit/post/post_cubit.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/interface/i_post_repository.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  // Services
  MockSpec<PackageInfo>(),
  MockSpec<DeviceInfoPlugin>(),
  MockSpec<SharedPreferences>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<UserService>(),
  MockSpec<AuthService>(),
  MockSpec<PostService>(),
  // Repositories
  MockSpec<ILocalStorageRepository>(),
  MockSpec<IUserRepository>(),
  MockSpec<IAuthRepository>(),
  MockSpec<IPostRepository>(),
  MockSpec<IAssetRepository>(),
  MockSpec<IAppLocalizationRepository>(),
  // Cubits
  MockSpec<AuthCubit>(),
  MockSpec<AppCoreCubit>(),
  MockSpec<HidableCubit>(),
  MockSpec<PostCubit>(),
  MockSpec<AppLocalizationCubit>(),
  // Others
  MockSpec<StreamSubscription<dynamic>>(),
  MockSpec<GoRouter>(),
  MockSpec<GoRouterDelegate>(),
  MockSpec<StatefulNavigationShell>(),
  MockSpec<RouteMatchList>(),
  MockSpec<FailureHandler>(),
])
void main() {}
