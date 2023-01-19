import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/app/constants/enum.dart';
import 'package:my_app/core/domain/bloc/my_app/my_app_bloc.dart';
import 'package:my_app/features/profile/presentation/screens/profile_screen.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';
import 'profile_screen_test.mocks.dart';

@GenerateMocks(<Type>[MyAppBloc])
void main() {
  late MockMyAppBloc myAppBloc;

  setUp(() {
    myAppBloc = MockMyAppBloc();

    when(myAppBloc.stream).thenAnswer(
      (_) => Stream<MyAppState>.fromIterable(<MyAppState>[
        MyAppState.initial().copyWith(
          authStatus: AuthStatus.authenticated,
          user: mockUser,
          isLoading: false,
        ),
      ]),
    );
    when(myAppBloc.state).thenAnswer(
      (_) => MyAppState.initial().copyWith(
        authStatus: AuthStatus.authenticated,
        user: mockUser,
        isLoading: false,
      ),
    );
  });
  Widget buildProfileScreen() => BlocProvider<MyAppBloc>(
        create: (BuildContext context) => myAppBloc,
        child: const MockMaterialApp(
          child: Scaffold(
            body: ProfileScreen(),
          ),
        ),
      );

  group('Profile Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'profile_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: buildProfileScreen,
          ),
        ],
      ),
    );
  });
}
