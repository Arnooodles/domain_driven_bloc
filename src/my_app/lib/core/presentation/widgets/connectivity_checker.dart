import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/constants/enum.dart';
import 'package:my_app/app/utils/connectivity_utils.dart';
import 'package:my_app/app/utils/dialog_utils.dart';
import 'package:my_app/app/utils/injection.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({super.key, required this.child});

  final Widget child;

  static Widget scaffold({
    required Widget body,
    Color? backgroundColor,
  }) =>
      ConnectivityChecker(
        child: SafeArea(
          child: Scaffold(
            body: body,
            backgroundColor: backgroundColor,
          ),
        ),
      );

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    final ConnectivityUtils connectivityUtils = getIt<ConnectivityUtils>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await connectivityUtils.checkInternet() == ConnectionStatus.offline &&
          !_isDialogShowing) {
        _isDialogShowing = true;
        await DialogUtils.showSnackbar(
          context,
          ConnectionStatus.offline.name.capitalize(),
        );
        _isDialogShowing = false;
      }

      _connectionSubscription ??= connectivityUtils
          .internetStatus()
          .listen((ConnectionStatus event) async {
        if (event == ConnectionStatus.offline && !_isDialogShowing) {
          _isDialogShowing = true;
          await DialogUtils.showSnackbar(
            context,
            ConnectionStatus.offline.name.capitalize(),
          );
          _isDialogShowing = false;
        }
      });
    });

    return widget.child;
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
