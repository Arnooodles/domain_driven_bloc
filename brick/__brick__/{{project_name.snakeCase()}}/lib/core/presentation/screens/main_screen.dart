import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/injection.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/theme/theme_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/model/user.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_nav_bar.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final Color iconColor = context.colorScheme.onSecondaryContainer;

    return WillPopScope(
      onWillPop: () => DialogUtils.showExitDialog(context),
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<PostBloc>(
            create: (BuildContext context) => getIt<PostBloc>(),
          ),
        ],
        child: BlocSelector<AuthBloc, AuthState, User?>(
          selector: (AuthState state) => state.user,
          builder: (BuildContext context, User? user) => ConnectivityChecker(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppTheme.defaultAppBarHeight),
                child: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
                  titleColor: context.colorScheme.primary,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => context
                          .read<ThemeBloc>()
                          .switchTheme(Theme.of(context).brightness),
                      icon: Theme.of(context).brightness == Brightness.dark
                          ? Icon(Icons.light_mode, color: iconColor)
                          : Icon(Icons.dark_mode, color: iconColor),
                    ),
                    if (user != null)
                      GestureDetector(
                        onTap: () => GoRouter.of(context)
                            .goNamed(RouteName.profile.name),
                        child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar(
                          size: 32,
                          imageUrl: user.avatar?.getOrCrash(),
                          padding: EdgeInsets.all(Insets.sm),
                        ),
                      ),
                  ],
                  leading: GoRouter.of(context).location.contains('/home/')
                      ? BackButton(
                          onPressed: () => GoRouter.of(context).canPop()
                              ? GoRouter.of(context).pop()
                              : null,
                        )
                      : null,
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Constant.mobileBreakpoint,
                    ),
                    child: child,
                  ),
                ),
              ),
              bottomNavigationBar: BlocSelector<AppCoreBloc, AppCoreState,
                  Map<AppScrollController, ScrollController>>(
                selector: (AppCoreState state) => state.scrollControllers,
                builder: (
                  BuildContext context,
                  Map<AppScrollController, ScrollController> scrollControllers,
                ) =>
                    {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar(scrollControllers: scrollControllers),
              ),
              backgroundColor: context.colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
