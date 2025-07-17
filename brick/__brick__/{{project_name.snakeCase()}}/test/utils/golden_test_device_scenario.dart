import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/app/helpers/extensions/build_context_ext.dart';

import 'mock_device.dart';

class GoldenTestDeviceScenario extends StatelessWidget {
  const GoldenTestDeviceScenario({
    required this.name,
    required this.builder,
    this.device = MockDevice.iphone11,
    super.key,
  });
  final String name;
  final MockDevice device;
  final ValueGetter<Widget> builder;

  @override
  Widget build(BuildContext context) => GoldenTestScenario(
    name: '$name (device: ${device.name})',
    child: ClipRect(
      child: MediaQuery(
        data: context.mediaQuery.copyWith(
          size: device.size,
          padding: device.safeArea,
          platformBrightness: device.brightness,
          devicePixelRatio: device.devicePixelRatio,
          textScaler: TextScaler.linear(device.textScale),
        ),
        child: SizedBox(width: device.size.width, height: device.size.height, child: builder()),
      ),
    ),
  );
}
