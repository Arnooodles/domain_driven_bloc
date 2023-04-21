import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/screens/home_screen.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';
import 'home_screen_test.mocks.dart';

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<PostBloc>(),
    MockSpec<AppCoreBloc>(),
  ],
)
void main() {
  late MockPostBloc postBlocInitial;
  late MockPostBloc postBlocWithPosts;
  late MockAppCoreBloc appCoreBloc;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    postBlocInitial = MockPostBloc();
    postBlocWithPosts = MockPostBloc();
    appCoreBloc = MockAppCoreBloc();

    scrollControllers = <AppScrollController, ScrollController>{
      AppScrollController.home: ScrollController(),
      AppScrollController.profile: ScrollController(),
    };

    when(appCoreBloc.stream).thenAnswer(
      (_) => Stream<AppCoreState>.fromIterable(
        <AppCoreState>[
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
        ],
      ),
    );
    when(appCoreBloc.state).thenAnswer(
      (_) =>
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
    );
    when(appCoreBloc.getScrollController(any))
        .thenAnswer((_) => ScrollController());
    when(postBlocInitial.stream).thenAnswer(
      (_) => Stream<PostState>.fromIterable(
        <PostState>[const PostState.loading()],
      ),
    );
    when(postBlocInitial.state).thenAnswer((_) => const PostState.loading());
    when(postBlocWithPosts.stream).thenAnswer(
      (_) => Stream<PostState>.fromIterable(
        <PostState>[PostState.success(mockPosts)],
      ),
    );
    when(postBlocWithPosts.state)
        .thenAnswer((_) => PostState.success(mockPosts));
  });

  Widget buildHomeScreen(PostBloc postBloc) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<PostBloc>(
            create: (BuildContext context) => postBloc,
          ),
          BlocProvider<AppCoreBloc>(
            create: (BuildContext context) => appCoreBloc,
          ),
        ],
        child: const MockMaterialApp(
          child: Scaffold(
            body: HomeScreen(),
          ),
        ),
      );

  group('Home Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'home_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'initial',
            builder: () => buildHomeScreen(postBlocInitial),
          ),
          GoldenTestDeviceScenario(
            name: 'with posts',
            builder: () => buildHomeScreen(postBlocWithPosts),
          ),
        ],
      ),
    );
  });
}
