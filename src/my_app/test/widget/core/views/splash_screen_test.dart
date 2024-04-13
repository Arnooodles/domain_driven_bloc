import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/presentation/views/splash_screen.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_material_app.dart';
import '../../../utils/test_utils.dart';
import 'splash_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthBloc>(),
  MockSpec<AppCoreBloc>(),
])
void main() {
  late MockAuthBloc authBloc;
  late MockAppCoreBloc appCoreBloc;

  Widget buildSplashScreen(AuthBloc authBloc) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => authBloc,
          ),
          BlocProvider<AppCoreBloc>(
            create: (BuildContext context) => appCoreBloc,
          ),
        ],
        child: const MockMaterialApp(
          child: SplashScreen(),
        ),
      );

  group(SplashScreen, () {
    setUp(() {
      authBloc = MockAuthBloc();
      appCoreBloc = MockAppCoreBloc();

      final AuthState authState = AuthState.authenticated(user: mockUser);
      provideDummy(authState);
      when(authBloc.stream).thenAnswer(
        (_) => Stream<AuthState>.fromIterable(<AuthState>[authState]),
      );
      when(authBloc.state).thenReturn(authState);
    });

    tearDown(() => authBloc.close());

    goldenTest(
      'renders correctly',
      fileName: 'splash_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: () => buildSplashScreen(authBloc),
          ),
        ],
      ),
    );
  });
}
