import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/route.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/error_message_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/injection.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/{{project_name.snakeCase()}}/{{project_name.snakeCase()}}_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/screens/error_screen.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/screens/loading_screen.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/connectivity_checker.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_app_bar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_avatar.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_nav_bar.dart';
import 'package:{{project_name.snakeCase()}}/features/home/domain/bloc/post/post_bloc.dart';

class {{#pascalCase}}{{project_name}}{{/pascalCase}}Screen extends StatelessWidget {
  const {{#pascalCase}}{{project_name}}{{/pascalCase}}Screen({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => DialogUtils.showExitDialog(context),
        child: MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<PostBloc>(
              create: (BuildContext context) => getIt<PostBloc>(),
            ),
          ],
          child: BlocBuilder<{{#pascalCase}}{{project_name}}{{/pascalCase}}Bloc, {{#pascalCase}}{{project_name}}{{/pascalCase}}State>(
            builder: (BuildContext context, {{#pascalCase}}{{project_name}}{{/pascalCase}}State state) {
              if (state.failure != null) {
                return ErrorScreen(
                  onRefresh: () =>
                      context.read<{{#pascalCase}}{{project_name}}{{/pascalCase}}Bloc>().initialize(),
                  errorMessage:
                      ErrorMessageUtils.generate(context, state.failure),
                );
              } else if (state.user != null) {
                return ConnectivityChecker(
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize:
                          Size.fromHeight(AppBar().preferredSize.height),
                      child: {{#pascalCase}}{{project_name}}{{/pascalCase}}AppBar(
                        actions: <Widget>[
                          IconButton(
                            onPressed: () => context
                                .read<{{#pascalCase}}{{project_name}}{{/pascalCase}}Bloc>()
                                .switchTheme(Theme.of(context).brightness),
                            icon:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Icon(Icons.light_mode)
                                    : const Icon(Icons.dark_mode),
                          ),
                          GestureDetector(
                            onTap: () => GoRouter.of(context)
                                .goNamed(RouteName.profile.name),
                            child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Avatar(
                              size: 32,
                              imageUrl: state.user!.avatar?.getOrCrash(),
                              padding: EdgeInsets.all(Insets.sm),
                            ),
                          ),
                        ],
                        leading: GoRouter.of(context)
                                .location
                                .contains('/home/')
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
                    bottomNavigationBar: const {{#pascalCase}}{{project_name}}{{/pascalCase}}NavBar(),
                  ),
                );
              } else {
                return LoadingScreen.scaffold();
              }
            },
          ),
        ),
      );
}
