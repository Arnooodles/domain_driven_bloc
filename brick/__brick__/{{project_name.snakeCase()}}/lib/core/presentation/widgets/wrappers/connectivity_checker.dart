import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/injection/service_locator.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_spacing.dart';
import 'package:{{project_name.snakeCase()}}/app/themes/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/connectivity_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/entity/enum/connection_status.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/wrappers/unfocusable_scaffold.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({required this.child, super.key});

  final Widget child;

  static Widget scaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
    bool isUnfocusable = false,
  }) =>
      ConnectivityChecker(
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
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  bool _isDialogShowing = false;
  FlashController<void>? _controller;

  Future<void> _showOfflineDialog(BuildContext context) async {
    await showFlash<void>(
      context: context,
      builder: (BuildContext context, FlashController<void> controller) {
        _controller = controller;
        return FlashBar<void>(
          controller: controller,
          position: FlashPosition.top,
          behavior: FlashBehavior.floating,
          margin: Paddings.allXxxLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.defaultBoardRadius,
          ),
          clipBehavior: Clip.antiAlias,
          icon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: fpdart.right(Icons.wifi_off)),
          content: Padding(
            padding: Paddings.horizontalSmall,
            child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
              text: context.i18n.common.error.no_internet_connection,
              style: context.textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onStatusChanged(ConnectionStatus connectionStatus) async {
    switch (connectionStatus) {
      case ConnectionStatus.offline:
        if (!_isDialogShowing) {
          _isDialogShowing = true;
          await _showOfflineDialog(context);
          _isDialogShowing = false;
        }
      case ConnectionStatus.online:
        if (_isDialogShowing) {
          await _controller?.dismiss();
          _isDialogShowing = false;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _onStatusChanged(await _connectivityUtils.checkInternet());
      _connectionSubscription ??= _connectivityUtils
          .internetStatus()
          .listen((ConnectionStatus event) async {
        await _onStatusChanged(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
