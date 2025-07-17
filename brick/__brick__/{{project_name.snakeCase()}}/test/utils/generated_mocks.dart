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
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_localization/app_localization_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/hidable/hidable_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_local_storage_repository.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/interface/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/service/auth_service.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/interface/i_auth_repository.dart';
import 'package:{{project_name.snakeCase()}}/features/home/data/service/post_service.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
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
  // Blocs
  MockSpec<AuthBloc>(),
  MockSpec<AppCoreBloc>(),
  MockSpec<HidableBloc>(),
  MockSpec<PostBloc>(),
  MockSpec<AppLocalizationBloc>(),
  // Others
  MockSpec<StreamSubscription<dynamic>>(),
  MockSpec<GoRouter>(),
  MockSpec<GoRouterDelegate>(),
  MockSpec<StatefulNavigationShell>(),
  MockSpec<RouteMatchList>(),
  MockSpec<FailureHandler>(),
])
void main() {}
