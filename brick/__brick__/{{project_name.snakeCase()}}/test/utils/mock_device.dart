import 'dart:ui';

import 'package:flutter/widgets.dart';

class MockDevice {
  const MockDevice({
    required this.size,
    required this.name,
    this.devicePixelRatio = 1.0,
    this.textScale = 1.0,
    this.brightness = Brightness.light,
    this.safeArea = EdgeInsets.zero,
  });

  /// [phone] one of the smallest phone screens
  static const MockDevice phone = MockDevice(name: 'phone', size: Size(375, 667));

  /// [iphone11] matches specs of iphone11, but with lower DPI for performance
  static const MockDevice iphone11 = MockDevice(
    name: 'iphone11',
    size: Size(414, 896),
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  );

  /// [tabletLandscape] example of tablet that in landscape mode
  static const MockDevice tabletLandscape = MockDevice(name: 'tablet_landscape', size: Size(1366, 1024));

  /// [tabletPortrait] example of tablet that in portrait mode
  static const MockDevice tabletPortrait = MockDevice(name: 'tablet_portrait', size: Size(1024, 1366));

  /// [name] specify device name. Ex: Phone, Tablet, Watch

  final String name;

  /// [size] specify device screen size. Ex: Size(1366, 1024))
  final Size size;

  /// [devicePixelRatio] specify device Pixel Ratio
  final double devicePixelRatio;

  /// [textScale] specify custom text scale
  final double textScale;

  /// [brightness] specify platform brightness
  final Brightness brightness;

  /// [safeArea] specify AppSizes to define a safe area
  final EdgeInsets safeArea;

  /// [copyWith] convenience function for [MockDevice] modification
  MockDevice copyWith({
    Size? size,
    double? devicePixelRatio,
    String? name,
    double? textScale,
    Brightness? brightness,
    EdgeInsets? safeArea,
  }) => MockDevice(
    size: size ?? this.size,
    devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    name: name ?? this.name,
    textScale: textScale ?? this.textScale,
    brightness: brightness ?? this.brightness,
    safeArea: safeArea ?? this.safeArea,
  );

  /// [dark] convenience method to copy the current device and apply dark theme
  MockDevice dark() => MockDevice(
    size: size,
    devicePixelRatio: devicePixelRatio,
    textScale: textScale,
    brightness: Brightness.dark,
    safeArea: safeArea,
    // ignore: unnecessary_string_escapes
    name: '$name\_dark',
  );

  @override
  String toString() =>
      'Device: $name, ${size.width}x${size.height} @ $devicePixelRatio, text: $textScale, $brightness, safe: $safeArea';
}
