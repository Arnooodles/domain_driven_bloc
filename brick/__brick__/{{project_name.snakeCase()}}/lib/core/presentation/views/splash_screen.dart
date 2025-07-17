import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_device/safe_device.dart';
import 'package:{{project_name.snakeCase()}}/app/constants/constant.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';
import 'package:{{project_name.snakeCase()}}/app/utils/dialog_utils.dart';
import 'package:{{project_name.snakeCase()}}/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_icon.dart';
import 'package:{{project_name.snakeCase()}}/core/presentation/widgets/{{project_name.snakeCase()}}_text.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/domain/bloc/auth/auth_bloc.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  void _initialize(BuildContext context) => WidgetsBinding.instance.addPostFrameCallback(
    (_) async => await _isDeviceSafe() && context.mounted
        ? await _initializeBlocs(context)
        : await _showUnsupportedDeviceDialog(context),
  );

  Future<void> _initializeBlocs(BuildContext context) async {
    if (context.mounted) {
      await Future.wait(<Future<void>>[
        context.read<AppCoreBloc>().initialize(),
        context.read<AuthBloc>().initialize(),
      ]);
    }
  }

  Future<void> _showUnsupportedDeviceDialog(BuildContext context) async {
    DialogUtils.showError(
      context.i18n.common.error.unsupported_device,
      icon: {{#pascalCase}}{{project_name}}{{/pascalCase}}Icon(icon: right(Icons.mobile_off)),
      isDismissable: false,
      alignment: Alignment.bottomCenter,
    );
  }

  Future<bool> _isDeviceSafe() async {
    if (kDebugMode || kProfileMode) {
      return true;
    } else {
      final bool isDevice =
          defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
      if (isDevice) {
        final List<bool> results = await Future.wait(<Future<bool>>[SafeDevice.isRealDevice, SafeDevice.isJailBroken]);

        final bool isRealDevice = results[0];
        final bool isJailBroken = results[1];
        return !isJailBroken && isRealDevice;
      } else {
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _initialize(context);
      return null;
    }, <Object?>[]);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Flexible(
                child: Center(
                  child: {{#pascalCase}}{{project_name}}{{/pascalCase}}Text(
                    text: Constant.appName,
                    textAlign: TextAlign.center,
                    style: context.textTheme.displayLarge,
                  ),
                ),
              ),
              const Flexible(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
