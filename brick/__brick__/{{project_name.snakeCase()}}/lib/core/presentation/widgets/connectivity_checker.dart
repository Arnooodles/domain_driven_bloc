import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/enum.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/connectivity_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/injection.dart';

class ConnectivityChecker extends HookWidget {
  const ConnectivityChecker({super.key, required this.child});

  final Widget child;

  static Widget scaffold({
    required Widget body,
    Color? backgroundColor,
  }) =>
      ConnectivityChecker(
        child: Scaffold(
          body: SafeArea(child: body),
          backgroundColor: backgroundColor,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ConnectivityUtils connectivityUtils = getIt<ConnectivityUtils>();

    useEffect(
      () {
        connectivityUtils
            .internetStatus()
            .listen((ConnectionStatus event) async {
          if (event == ConnectionStatus.offline) {
            await DialogUtils.showSnackbar(
              context,
              ConnectionStatus.offline.name.capitalize(),
            );
          }
        }).cancel();

        return null;
      },
      <dynamic>[],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await connectivityUtils.checkInternet() == ConnectionStatus.offline) {
        await DialogUtils.showSnackbar(
          context,
          ConnectionStatus.offline.name.capitalize(),
        );
      }
    });

    return child;
  }
}
