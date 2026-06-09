import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:toastification/toastification.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/future_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/connectivity_utils.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/connection_status.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/unfocusable_scaffold.dart';

class ConnectivityChecker extends HookWidget {
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
  Widget build(BuildContext context) {
    final ConnectivityUtils connectivityUtils = getIt<ConnectivityUtils>();
    final ObjectRef<ToastificationItem?> toastificationItemRef = useRef<ToastificationItem?>(null);

    useEffect(() {
      Future<ToastificationItem> showOfflineDialog() async => DialogUtils.showError(
        context.i18n.common.error.no_internet_connection,
        icon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: fpdart.right(Icons.wifi_off)),
        isDismissable: false,
      );

      Future<void> onStatusChanged(ConnectionStatus connectionStatus) async {
        if (!context.mounted) return;
        switch (connectionStatus) {
          case ConnectionStatus.offline:
            if (toastificationItemRef.value?.isRunning ?? false) return;
            toastificationItemRef.value ??= await showOfflineDialog();
          case ConnectionStatus.online:
            if (toastificationItemRef.value != null) {
              toastification.dismiss(toastificationItemRef.value!);
              toastificationItemRef.value = null;
            }
        }
      }

      final StreamSubscription<ConnectionStatus> connectionSubscription = connectivityUtils.internetStatus.listen(
        onStatusChanged,
      );

      return () {
        unawaited(connectionSubscription.cancel().logOnError());
        if (toastificationItemRef.value != null) {
          toastification.dismiss(toastificationItemRef.value!);
          toastificationItemRef.value = null;
        }
      };
    }, <Object?>[connectivityUtils]);

    return child;
  }
}
