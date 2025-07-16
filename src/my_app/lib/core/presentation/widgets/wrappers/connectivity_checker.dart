import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:toastification/toastification.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/helpers/injection/service_locator.dart';
import 'package:very_good_core/app/utils/connectivity_utils.dart';
import 'package:very_good_core/app/utils/dialog_utils.dart';
import 'package:very_good_core/core/domain/entity/enum/connection_status.dart';
import 'package:very_good_core/core/presentation/widgets/very_good_core_icon.dart';
import 'package:very_good_core/core/presentation/widgets/wrappers/unfocusable_scaffold.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({required this.child, super.key});

  final Widget child;

  static Widget scaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
    bool isUnfocusable = false,
  }) => ConnectivityChecker(
    child: isUnfocusable
        ? UnfocusableScaffold(
            body: body,
            appBar: appBar,
            backgroundColor: backgroundColor,
            bottomNavigationBar: bottomNavigationBar,
          )
        : Scaffold(
            body: body,
            appBar: appBar,
            backgroundColor: backgroundColor,
            bottomNavigationBar: bottomNavigationBar,
          ),
  );

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  final ConnectivityUtils _connectivityUtils = getIt<ConnectivityUtils>();
  late final StreamSubscription<ConnectionStatus> _connectionSubscription;
  ToastificationItem? _toastificationItem;

  Future<ToastificationItem> _showOfflineDialog(BuildContext context) async => DialogUtils.showError(
    context.i18n.common.error.no_internet_connection,
    icon: VeryGoodCoreIcon(icon: fpdart.right(Icons.wifi_off)),
    isDismissable: false,
  );

  Future<void> _onStatusChanged(ConnectionStatus connectionStatus) async {
    if (!mounted) return;
    switch (connectionStatus) {
      case ConnectionStatus.offline:
        if (_toastificationItem?.isRunning ?? false) return;
        _toastificationItem ??= await _showOfflineDialog(context);
      case ConnectionStatus.online:
        if (_toastificationItem != null) {
          toastification.dismiss(_toastificationItem!);
          _toastificationItem = null;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    _connectionSubscription = _connectivityUtils.internetStatus.listen(_onStatusChanged);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
