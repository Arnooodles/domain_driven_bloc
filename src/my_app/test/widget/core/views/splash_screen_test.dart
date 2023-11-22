import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_core/core/presentation/views/splash_screen.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

import '../../../utils/golden_test_device_scenario.dart';
import '../../../utils/mock_material_app.dart';
import '../../../utils/test_utils.dart';
import 'splash_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthBloc>(),
])
void main() {
  late MockAuthBloc authBloc;

  Widget buildSplashScreen(AuthBloc authBloc) => BlocProvider<AuthBloc>(
        create: (BuildContext context) => authBloc,
        child: const MockMaterialApp(
          child: Scaffold(body: SplashScreen()),
        ),
      );

  group('Splash Screen Tests', () {
    setUp(() {
      authBloc = MockAuthBloc();

      final AuthState authState = AuthState.authenticated(user: mockUser);
      when(authBloc.stream).thenAnswer(
        (_) => Stream<AuthState>.fromIterable(<AuthState>[authState]),
      );
      when(authBloc.state).thenReturn(authState);
    });

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
