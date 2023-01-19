import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/app/constants/constant.dart';
import 'package:my_app/app/utils/dialog_utils.dart';
import 'package:my_app/app/utils/error_message_utils.dart';
import 'package:my_app/app/utils/injection.dart';
import 'package:my_app/core/domain/bloc/my_app/my_app_bloc.dart';
import 'package:my_app/core/presentation/screens/error_screen.dart';
import 'package:my_app/core/presentation/screens/loading_screen.dart';
import 'package:my_app/core/presentation/widgets/connectivity_checker.dart';
import 'package:my_app/core/presentation/widgets/my_app_app_bar.dart';
import 'package:my_app/core/presentation/widgets/my_app_nav_bar.dart';
import 'package:my_app/features/home/domain/bloc/post/post_bloc.dart';

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => DialogUtils.showExitDialog(context),
        child: MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<PostBloc>(
              create: (BuildContext context) => getIt<PostBloc>(),
            ),
          ],
          child: BlocBuilder<MyAppBloc, MyAppState>(
            builder: (BuildContext context, MyAppState state) {
              if (state.failure != null) {
                return ErrorScreen(
                  onRefresh: () => context.read<MyAppBloc>().initialize(),
                  errorMessage:
                      ErrorMessageUtils.generate(context, state.failure),
                );
              } else if (state.user != null) {
                return ConnectivityChecker(
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize:
                          Size.fromHeight(AppBar().preferredSize.height),
                      child: MyAppAppBar(
                        avatar: state.user!.avatar,
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
                    bottomNavigationBar: const MyAppNavBar(),
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
