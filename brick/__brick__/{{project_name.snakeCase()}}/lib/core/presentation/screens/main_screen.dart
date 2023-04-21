import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route_name.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/theme/theme_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_nav_bar.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    required this.child,
    super.key,
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
        child: ConnectivityChecker.scaffold(
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
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (BuildContext context, AuthState state) =>
                      state.maybeMap(
                    orElse: SizedBox.shrink,
                    authenticated: (Authenticated state) => GestureDetector(
                      onTap: () =>
                          GoRouter.of(context).goNamed(RouteName.profile.name),
                      child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar(
                        size: 32,
                        imageUrl: state.user.avatar?.getOrCrash(),
                        padding: const EdgeInsets.all(Insets.small),
                      ),
                    ),
                  ),
                )
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
    );
  }
}
