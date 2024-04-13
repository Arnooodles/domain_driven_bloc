import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:safe_device/safe_device.dart';
import 'package:very_good_core/app/helpers/extensions/build_context_ext.dart';
import 'package:very_good_core/app/themes/app_spacing.dart';
import 'package:very_good_core/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:very_good_core/core/presentation/widgets/app_title.dart';
import 'package:very_good_core/features/auth/domain/bloc/auth/auth_bloc.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  void _initialize(BuildContext context) =>
      WidgetsBinding.instance.addPostFrameCallback(
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
    await showFlash<void>(
      context: context,
      builder: (BuildContext context, FlashController<void> controller) =>
          FlashBar<void>(
        controller: controller,
        dismissDirections: const <FlashDismissDirection>[],
        elevation: 3,
        backgroundColor: context.colorScheme.background,
        surfaceTintColor: context.colorScheme.surfaceTint,
        indicatorColor: context.colorScheme.error,
        shouldIconPulse: false,
        icon: Icon(Icons.mobile_off, color: context.colorScheme.onSurface),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
          child: Text(
            context.l10n.common_error_unsupported_device,
            style: TextStyle(color: context.colorScheme.onBackground),
          ),
        ),
      ),
    );
  }

  Future<bool> _isDeviceSafe() async {
    if (kDebugMode || kProfileMode) {
      return true;
    } else {
      final bool isDevice = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android;
      if (isDevice) {
        final List<bool> results = await Future.wait(<Future<bool>>[
          SafeDevice.isRealDevice,
          SafeDevice.isJailBroken,
        ]);

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
    useEffect(
      () {
        _initialize(context);
        return null;
      },
      <Object?>[],
    );

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: const SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Flexible(
                child: Center(
                  child: AppTitle(),
                ),
              ),
              Flexible(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
